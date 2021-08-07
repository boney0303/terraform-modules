resource "aws_lb" "demo_project_alb" {
count = var.create_lb ? 1 : 0
name_prefix = var.name_prefix

load_balancer_type = var.load_balancer_type
internal           = var.internal
security_groups    = var.security_groups
subnets            = var.subnets

idle_timeout                     = var.idle_timeout
enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
enable_deletion_protection       = var.enable_deletion_protection
  
tags = merge(
    var.tags,
    var.lb_tags,
    {
      Name = var.name != null ? var.name : var.name_prefix
    },
  )
timeouts {
    create = var.load_balancer_create_timeout
    update = var.load_balancer_update_timeout
    delete = var.load_balancer_delete_timeout
  }

}

resource "aws_lb_target_group" "demo_project_alb_tg" {
count = var.create_lb ? length(var.target_groups) : 0
name_prefix = lookup(var.target_groups[count.index], "name_prefix", null)

vpc_id      = var.vpc_id
port        = lookup(var.target_groups[count.index], "backend_port", null)
protocol    = lookup(var.target_groups[count.index], "backend_protocol", null) != null ? upper(lookup(var.target_groups[count.index], "backend_protocol")) : null
target_type = lookup(var.target_groups[count.index], "target_type", null)
deregistration_delay               = lookup(var.target_groups[count.index], "deregistration_delay", null)

dynamic "health_check" {
    for_each = length(keys(lookup(var.target_groups[count.index], "health_check", {}))) == 0 ? [] : [lookup(var.target_groups[count.index], "health_check", {})]

    content {
      enabled             = lookup(health_check.value, "enabled", null)
      interval            = lookup(health_check.value, "interval", null)
      path                = lookup(health_check.value, "path", null)
      port                = lookup(health_check.value, "port", null)
      healthy_threshold   = lookup(health_check.value, "healthy_threshold", null)
      unhealthy_threshold = lookup(health_check.value, "unhealthy_threshold", null)
      timeout             = lookup(health_check.value, "timeout", null)
      protocol            = lookup(health_check.value, "protocol", null)
      matcher             = lookup(health_check.value, "matcher", null)
    }
  }

dynamic "stickiness" {
    for_each = length(keys(lookup(var.target_groups[count.index], "stickiness", {}))) == 0 ? [] : [lookup(var.target_groups[count.index], "stickiness", {})]

    content {
      enabled         = lookup(stickiness.value, "enabled", null)
      cookie_duration = lookup(stickiness.value, "cookie_duration", null)
      type            = lookup(stickiness.value, "type", null)
    }
  }

tags = merge(
    var.tags,
    var.target_group_tags,
    lookup(var.target_groups[count.index], "tags", {}),
    {
      "Name" = lookup(var.target_groups[count.index], "name", lookup(var.target_groups[count.index], "name_prefix", ""))
    },
  )

depends_on = [aws_lb.demo_project_alb]

lifecycle {
    create_before_destroy = true
  }

}

resource "aws_lb_listener" "frontend_http_tcp" {
count = var.create_lb ? length(var.http_tcp_listeners) : 0

load_balancer_arn = aws_lb.demo_project_alb[0].arn

port     = var.http_tcp_listeners[count.index]["port"]
protocol = var.http_tcp_listeners[count.index]["protocol"]

dynamic "default_action" {
    for_each = length(keys(var.http_tcp_listeners[count.index])) == 0 ? [] : [var.http_tcp_listeners[count.index]]

    # Defaults to forward action if action_type not specified
    content {
      type             = lookup(default_action.value, "action_type", "forward")
      target_group_arn = contains([null, "", "forward"], lookup(default_action.value, "action_type", "")) ? aws_lb_target_group.demo_project_alb_tg[lookup(default_action.value, "target_group_index", count.index)].id : null

      dynamic "redirect" {
        for_each = length(keys(lookup(default_action.value, "redirect", {}))) == 0 ? [] : [lookup(default_action.value, "redirect", {})]

        content {
          path        = lookup(redirect.value, "path", null)
          host        = lookup(redirect.value, "host", null)
          port        = lookup(redirect.value, "port", null)
          protocol    = lookup(redirect.value, "protocol", null)
          query       = lookup(redirect.value, "query", null)
          status_code = redirect.value["status_code"]
        }
      }

      dynamic "fixed_response" {
        for_each = length(keys(lookup(default_action.value, "fixed_response", {}))) == 0 ? [] : [lookup(default_action.value, "fixed_response", {})]

        content {
          content_type = fixed_response.value["content_type"]
          message_body = lookup(fixed_response.value, "message_body", null)
          status_code  = lookup(fixed_response.value, "status_code", null)
        }
      }
    }
  }
}
