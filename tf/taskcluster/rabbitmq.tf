resource "rabbitmq_vhost" "vhost" {
  name = "${var.rabbitmq_vhost}"
}
