resource "aws_lb" "demo_webapp_alb" {
  count = var.create_lb ? 1 : 0
  name = var.name

  load_balancer_type = var.load_balancer_type
  internal = var.internal
  security_groups = var.security_groups
  subnets = var.subnets

  idle_timeout = var.idle_timeout
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_deletion_protection = var.enable_deletion_protection

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

resource "aws_lb_target_group" "demo_webapp_alb_tg" {
  count = var.create_lb ? length(var.target_groups) : 0
  name_prefix = lookup(var.target_groups[count.index], "name_prefix", null)

  vpc_id = var.vpc_id
  port = try(var.target_groups[count.index].backend_port, null)
  protocol = try(upper(var.target_groups[count.index].backend_protocol), null)
  protocol_version = try(upper(var.target_groups[count.index].protocol_version), null)
  target_type = try(var.target_groups[count.index].target_type, null)
  deregistration_delay = lookup(var.target_groups[count.index], "deregistration_delay", null)

  dynamic "health_check" {
    for_each = try([
      var.target_groups[count.index].health_check], [])

    content {
      enabled = try(health_check.value.enabled, null)
      interval = try(health_check.value.interval, null)
      path = try(health_check.value.path, null)
      port = try(health_check.value.port, null)
      healthy_threshold = try(health_check.value.healthy_threshold, null)
      unhealthy_threshold = try(health_check.value.unhealthy_threshold, null)
      timeout = try(health_check.value.timeout, null)
      protocol = try(health_check.value.protocol, null)
      matcher = try(health_check.value.matcher, null)
    }
  }

  dynamic "stickiness" {
    for_each = try([
      var.target_groups[count.index].stickiness], [])

    content {
      enabled = try(stickiness.value.enabled, null)
      cookie_duration = try(stickiness.value.cookie_duration, null)
      type = try(stickiness.value.type, null)
      cookie_name = try(stickiness.value.cookie_name, null)
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

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_lb_listener" "frontend_http_tcp" {
  count = var.create_lb ? length(var.http_tcp_listeners) : 0

  load_balancer_arn = aws_lb.demo_webapp_alb[0].arn

  port = var.http_tcp_listeners[count.index]["port"]
  protocol = var.http_tcp_listeners[count.index]["protocol"]

  dynamic "default_action" {
    for_each = length(keys(var.http_tcp_listeners[count.index])) == 0 ? [] : [var.http_tcp_listeners[count.index]]

    # Defaults to forward action if action_type not specified
    content {
      type = lookup(default_action.value, "action_type", "forward")
      target_group_arn = contains([null, ""], lookup(default_action.value, "action_type", "")) ? aws_lb_target_group.demo_webapp_alb_tg[lookup(default_action.value, "target_group_index", count.index)].id : null

      dynamic "redirect" {
        for_each = length(keys(lookup(default_action.value, "redirect", {}))) == 0 ? [] : [lookup(default_action.value, "redirect", {})]

        content {
          path = lookup(redirect.value, "path", null)
          host = lookup(redirect.value, "host", null)
          port = lookup(redirect.value, "port", null)
          protocol = lookup(redirect.value, "protocol", null)
          query = lookup(redirect.value, "query", null)
          status_code = redirect.value["status_code"]
        }
      }

      dynamic "fixed_response" {
        for_each = length(keys(lookup(default_action.value, "fixed_response", {}))) == 0 ? [] : [lookup(default_action.value, "fixed_response", {})]

        content {
          content_type = fixed_response.value["content_type"]
          message_body = lookup(fixed_response.value, "message_body", null)
          status_code = lookup(fixed_response.value, "status_code", null)
        }
      }
    }
  }

  tags = merge(
    var.tags,
    var.http_tcp_listeners_tags,
    lookup(var.http_tcp_listeners[count.index], "tags", {}),
  )
}
