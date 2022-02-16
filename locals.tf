##############################################################
# This module allows the creation of a Container Registry
##############################################################

locals {
  name = (var.name != null ? var.name : "${var.names.product}-${var.names.environment}-${var.names.location}")
}
