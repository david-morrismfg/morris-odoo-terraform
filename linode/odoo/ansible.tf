resource "local_file" "ansible_inventory" {
  filename = "${path.module}/ansible-playbook/inventory/hosts"
  content  = <<-EOT
  [mash_servers]
  odoo.${var.domain} ansible_host=${linode_instance.odoo.ip_address} ansible_ssh_user=root
  EOT

  depends_on = [linode_instance.odoo]
}

# Create Ansible host vars
resource "local_file" "ansible_host_vars" {
  filename = "${path.module}/ansible-playbook/inventory/host_vars/odoo.${var.domain}/vars.yml"
  content  = <<-EOT
    ---
    # Docker and base configuration
    mash_playbook_generic_secret_key: cheG5iph9roengaiquah3phainaex6Rah4Iqu1hai4eiw5laem9Aethahsi5pa5l
    mash_playbook_docker_installation_enabled: true
    devture_docker_sdk_for_python_installation_enabled: true
    devture_timesync_installation_enabled: true

    postgres_enabled: true
    postgres_connection_password: 'Ceocoo0aaPhe5yee7sah2eeh6vah2ok8Sofohch2rien3phie3aineeJaiquevai'
    postgres_postgres_process_extra_arguments_auto: [
      "-c 'max_connections=1000'",
      "-c 'shared_buffers=8192MB'",
      "-c 'effective_cache_size=24576MB'",
      "-c 'maintenance_work_mem=2048MB'",
      "-c 'checkpoint_completion_target=0.9'",
      "-c 'wal_buffers=16MB'",
      "-c 'default_statistics_target=100'",
      "-c 'random_page_cost=1.1'",
      "-c 'effective_io_concurrency=200'",
      "-c 'work_mem=24576kB'",
      "-c 'huge_pages=try'",
      "-c 'min_wal_size=80MB'",
      "-c 'max_wal_size=1024MB'",
      "-c 'max_worker_processes=16'",
      "-c 'max_parallel_workers=12'",
      "-c 'max_parallel_workers_per_gather=6'",
      "-c 'max_parallel_maintenance_workers=4'"
    ]

    # Traefik configuration
    mash_playbook_reverse_proxy_type: playbook-managed-traefik
    traefik_enabled: true
    traefik_config_certificatesResolvers_acme_email: djolley@morrismfg.com

    # Docker registry authentication for ghcr.io
    docker_registry_login_enabled: true
    docker_registry_login_username: "ayushin"
    docker_registry_login_password: "${var.github_pat}"
    docker_registry_login_registry: "ghcr.io"

    # Odoo configuration
    odoo_identifier: odoo
    odoo_base_path: "${var.odoo_path}"

    odoo_enabled: true
    odoo_routers:
      - hostname: ${var.domain}
        dbfilter: 'morris-erp'

    odoo_admin_password: "${var.odoo_password}"

    # Database configuration

    odoo_database_username: "odoo"
    odoo_database_hostname: "mash-postgres"
    odoo_database_password: "Iemishaepaing6boshieVeiph2oopael"

    # Container configuration
    odoo_container_image: ${var.odoo_image}
    odoo_container_labels_traefik_enabled: true
    odoo_container_labels_traefik_docker_network: "traefik"
    odoo_container_additional_networks:
      - "traefik"
      - "mash-postgres"
    odoo_container_http_host_bind_port: 127.0.0.1:8069

    odoo_config: |
      [options]
      addons_path = /mnt/extra-addons
      admin_passwd = ${var.odoo_password}
      data_dir = /var/lib/odoo
      limit_request = 8192
      limit_time_cpu = 360
      limit_time_real = 720
      list_db = True
      log_handler = :WARN
      gevent_port = 8072
      max_cron_threads = 1
      proxy_mode = True
      server_wide_modules = web,dbfilter_from_header
      workers = 25
  EOT

  depends_on = [linode_instance.odoo]
}
