data "aws_ami" "this" {
    most_recent = var.ami_config.most_recent
    owners      = var.ami_config.owners

    dynamic "filter" {
        for_each = var.ami_config.filters
        content {
            name   = filter.value.name
            values = filter.value.values
        } 
    }
}