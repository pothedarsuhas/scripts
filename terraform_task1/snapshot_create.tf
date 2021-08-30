# Basic Instance
resource "openstack_compute_instance_v2" "basic" {
  name            = "basic"
  image_id        = "ad091b52-742f-469e-8f3c-fd81cadf0743"
  flavor_id       = "3"
  key_pair        = "my_key_pair_name"
  security_groups = ["default"]

  metadata = {
    this = "that"
  }

  network {
    name = "my_network"
  }
}


# instance with attached volume
resource "openstack_blockstorage_volume_v2" "myvol" {
  name = "myvol"
  size = 1
}

resource "openstack_compute_instance_v2" "myinstance" {
  name            = "myinstance"
  image_id        = "ad091b52-742f-469e-8f3c-fd81cadf0743"
  flavor_id       = "3"
  key_pair        = "my_key_pair_name"
  security_groups = ["default"]

  network {
    name = "my_network"
  }
}

resource "openstack_compute_volume_attach_v2" "attached" {
  instance_id = "${openstack_compute_instance_v2.myinstance.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.myvol.id}"
}

#Boot From Volume
resource "openstack_compute_instance_v2" "boot-from-volume" {
  name            = "boot-from-volume"
  flavor_id       = "3"
  key_pair        = "my_key_pair_name"
  security_groups = ["default"]

  block_device {
    uuid                  = "<image-id>"
    source_type           = "image"
    volume_size           = 5
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = "my_network"
  }
}

#Boot From an Existing Volume
resource "openstack_blockstorage_volume_v1" "myvol" {
  name     = "myvol"
  size     = 5
  image_id = "<image-id>"
}

resource "openstack_compute_instance_v2" "boot-from-volume" {
  name            = "bootfromvolume"
  flavor_id       = "3"
  key_pair        = "my_key_pair_name"
  security_groups = ["default"]

  block_device {
    uuid                  = "${openstack_blockstorage_volume_v1.myvol.id}"
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = "my_network"
  }
}

#Boot Instance, Create Volume, and Attach Volume as a Block Device
resource "openstack_compute_instance_v2" "instance_1" {
  name            = "instance_1"
  image_id        = "<image-id>"
  flavor_id       = "3"
  key_pair        = "my_key_pair_name"
  security_groups = ["default"]

  block_device {
    uuid                  = "<image-id>"
    source_type           = "image"
    destination_type      = "local"
    boot_index            = 0
    delete_on_termination = true
  }

  block_device {
    source_type           = "blank"
    destination_type      = "volume"
    volume_size           = 1
    boot_index            = 1
    delete_on_termination = true
  }
}

#Boot Instance and Attach Existing Volume as a Block Device
resource "openstack_blockstorage_volume_v2" "volume_1" {
  name = "volume_1"
  size = 1
}

resource "openstack_compute_instance_v2" "instance_1" {
  name            = "instance_1"
  image_id        = "<image-id>"
  flavor_id       = "3"
  key_pair        = "my_key_pair_name"
  security_groups = ["default"]

  block_device {
    uuid                  = "<image-id>"
    source_type           = "image"
    destination_type      = "local"
    boot_index            = 0
    delete_on_termination = true
  }

  block_device {
    uuid                  = "${openstack_blockstorage_volume_v2.volume_1.id}"
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = 1
    delete_on_termination = true
  }
}

#Instance With Multiple Networks
resource "openstack_networking_floatingip_v2" "myip" {
  pool = "my_pool"
}

resource "openstack_compute_instance_v2" "multi-net" {
  name            = "multi-net"
  image_id        = "ad091b52-742f-469e-8f3c-fd81cadf0743"
  flavor_id       = "3"
  key_pair        = "my_key_pair_name"
  security_groups = ["default"]

  network {
    name = "my_first_network"
  }

  network {
    name = "my_second_network"
  }
}

resource "openstack_compute_floatingip_associate_v2" "myip" {
  floating_ip = "${openstack_networking_floatingip_v2.myip.address}"
  instance_id = "${openstack_compute_instance_v2.multi-net.id}"
  fixed_ip    = "${openstack_compute_instance_v2.multi-net.network.1.fixed_ip_v4}"
}

#Instance With Personality
resource "openstack_compute_instance_v2" "personality" {
  name            = "personality"
  image_id        = "ad091b52-742f-469e-8f3c-fd81cadf0743"
  flavor_id       = "3"
  key_pair        = "my_key_pair_name"
  security_groups = ["default"]

  personality {
    file    = "/path/to/file/on/instance.txt"
    content = "contents of file"
  }

  network {
    name = "my_network"
  }
}

#Instance with Multiple Ephemeral Disks
resource "openstack_compute_instance_v2" "multi-eph" {
  name            = "multi_eph"
  image_id        = "ad091b52-742f-469e-8f3c-fd81cadf0743"
  flavor_id       = "3"
  key_pair        = "my_key_pair_name"
  security_groups = ["default"]

  block_device {
    boot_index            = 0
    delete_on_termination = true
    destination_type      = "local"
    source_type           = "image"
    uuid                  = "<image-id>"
  }

  block_device {
    boot_index            = -1
    delete_on_termination = true
    destination_type      = "local"
    source_type           = "blank"
    volume_size           = 1
    guest_format          = "ext4"
  }

  block_device {
    boot_index            = -1
    delete_on_termination = true
    destination_type      = "local"
    source_type           = "blank"
    volume_size           = 1
  }
}

#Instance with Boot Disk and Swap Disk
resource "openstack_compute_flavor_v2" "flavor-with-swap" {
  name  = "flavor-with-swap"
  ram   = "8096"
  vcpus = "2"
  disk  = "20"
  swap  = "4096"
}

resource "openstack_compute_instance_v2" "vm-swap" {
  name            = "vm_swap"
  flavor_id       = "${openstack_compute_flavor_v2.flavor-with-swap.id}"
  key_pair        = "my_key_pair_name"
  security_groups = ["default"]

  block_device {
    boot_index            = 0
    delete_on_termination = true
    destination_type      = "local"
    source_type           = "image"
    uuid                  = "<image-id>"
  }

  block_device {
    boot_index            = -1
    delete_on_termination = true
    destination_type      = "local"
    source_type           = "blank"
    guest_format          = "swap"
    volume_size           = 4
  }
}

#Instance with User Data (cloud-init)
resource "openstack_compute_instance_v2" "instance_1" {
  name            = "basic"
  image_id        = "ad091b52-742f-469e-8f3c-fd81cadf0743"
  flavor_id       = "3"
  key_pair        = "my_key_pair_name"
  security_groups = ["default"]
  user_data       = "#cloud-config\nhostname: instance_1.example.com\nfqdn: instance_1.example.com"

  network {
    name = "my_network"
  }
}
