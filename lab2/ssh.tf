resource "aws_key_pair" "keypair" {
  key_name   = "cmtr-pf5k68pq-keypair"
  public_key = var.ssh_key

  tags = {
    Project = "epam-tf-lab"
    ID      = "cmtr-pf5k68pq"
  }
}
