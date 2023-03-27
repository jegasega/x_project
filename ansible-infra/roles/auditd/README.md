# **Telia Galera Cluster deployment Ansible role**
#### Table of Contents

1. [Overview](#overview)
2. [Role Description](#role-description)
3. [Usage](#usage)
5. [Parameters](#parameters)
6. [Usefull links](#usefulllinks)

## Overview

This Ansible role was created to preform Auditd service configuration on CentOS 6 and 7 systems

## Role Description

## Usage

#### Inventory file sample

```

[db_servers_segment_1]
db-1 primary_node=1 bootstrap_allowed=1
db-2
db-3
[db_servers_segment_2]

[all_db_servers:children]
db_servers_segment_1
db_servers_segment_2

```

#### Playbook example

```
---
- hosts: all_db_servers
  roles:
    - { role: galera_role, become: yes }
```
Command to run created playbook: `ansible-playbook --ssh-common-args='-o StrictHostKeyChecking=no' -i ./inventories/db_hosts.ini galera_confguration.yml -v`

If you are not happy with default parameters provided you can easily override them putting to the inventory file

####  Parameters

##### Default parameters we are using for this role at this moment are

```
primary_node: 0
bootstrap_allowed: 0
mariadb_release: 10.2
centos_release: 6

logrotate_folder: /etc/logrotate.d

mysql_config_folder: /opt/telia/my.cnf.d
application_dir: /opt/uxp
mysql_initial_data_dir: /var/lib/mysql
mysql_data_dir: "{{ application_dir }}/mysql"
mysql_log_dir: "{{ application_dir }}/logs/mysql"
mysql_connections_count: 15000
mysql_wait_timeout: 300
mysql_long_query_time: 0.1

galera_wsrep_cluster_name: galera_test_cluster
galera_sst_user: sstuser
galera_sst_password: sstpass
galera_slave_threads: 1
galera_cache_size: 1G
galera_segment_id: 0
galera_gmcast_timewait: "PT5S"
galera_cluster_interface: eth1
galera_cluster_interface_fact_var: ansible_{{ galera_cluster_interface }}

innodb_pool_instances: 4
innodb_buffer_size: 1024M
innodb_log_size: 256M

mysql_service_name: mysql
mysql_root_user: root
mysql_root_password: Passw0rd
mysql_uxp_user: uxp
mysql_uxp_password: Passw0rd
mysql_zabbix_user: zabbix
mysql_zabbix_password: bixzab123

db_application: mint_platform
db_application_batch: mint_application_batch
db_application_quartz: mint_application_quartz
```
##### Parameters description

* `primary_node` - indicates node is primary and can be participating in the bootstrap procedure. Also we are running all the MySQL commands on this node, beacuse it's not needed to run them on every node in the cluster.
* `bootstrap_allowed` - cluster bootstrap indicator. Allows node MySQL to be started in the bootstrap mode. Will work only if all the nodes in cluster are stopped (cluster completely crushed) 
* `mariadb_release` - MariaDB\Percona release
* `centos_release` - machine Centos version. (Will be replaced with the appropriate Ansible fact in the future)

* `logrotate_folder` - folder containg Logrotate configuration

* `mysql_config_folder` - folder containing main MySQL configuration file
* `application_dir` - main folder containing all the application parts
* `mysql_initial_data_dir` - Folder where MySQL package data is installed on the RPM install.
* `mysql_data_dir` - Folder MySQL data will be placed
* `mysql_log_dir` - MySQL log folder
* `mysql_connections_count` - Allowed mysql client connections count
* `mysql_wait_timeout` - MySQL idle connection wait timeout
* `mysql_long_query_time` - time after which queries will be logged to the Slow Query log file

* `galera_wsrep_cluster_name` - Galera cluster name
* `galera_sst_user` - Galera service user name
* `galera_sst_password` - Galera service user password
* `galera_slave_threads` - Defines the number of threads to use in applying slave write-sets
* `galera_cache_size` - Defines the disk space you want to node to use in caching write-sets
* `galera_segment_id` - Galera segment ID
* `galera_gmcast_timewait` - Time after which node will be marked as DOWN
* `galera_cluster_interface` - Network interface used for the cluster communication
* `galera_cluster_interface_fact_var` - additional value for network interface for Ansible template containg

* `innodb_pool_instances` - Number of the segments to which InnoDB bufer pool will be divided. Have sense only when buffer size is more than 1GB
* `innodb_buffer_size` - Size of the memory area where InnoDB caches table and index data
* `innodb_log_size` - Amount of disk space will be used to save the information needed during crash recovery, to restore an incomplete transaction.

* `mysql_service_name` - Name of service used on the system
* `mysql_root_user` - MySQL root user
* `mysql_root_password` - MySQL root password
* `mysql_uxp_user` - Application user
* `mysql_uxp_password` - Application user password
* `mysql_zabbix_user` - User we are using for the Zabbix monitoring
* `mysql_zabbix_password` - Zabbix user password

* `db_application` - application database name
* `db_application_batch` - application batch database name
* `db_application_quartz` - application quartz database name

## Usefull links
