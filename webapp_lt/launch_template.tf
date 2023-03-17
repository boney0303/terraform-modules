resource "aws_launch_template" "webapp_ec2_lt" {
    name_prefix   = "${var.stack_name}-lt-"

    image_id      = var.image_id
    instance_type = var.instance_type
    key_name      = var.ssh_key
    #vpc_security_group_ids = var.ec2_security_grps

    user_data = filebase64("${path.module}/templates/nginx_user_data.sh")

    iam_instance_profile {
        name = var.iam_instance_profile
    }

    monitoring {
        enabled = true
    }

    network_interfaces {
        associate_public_ip_address = false
        security_groups = var.ec2_security_grps
    }

    tag_specifications {
        resource_type = "instance"
        tags          = var.tags
    }

    tag_specifications {
        resource_type = "volume"
        tags          = var.tags
    }
}

