# **Telia Galera Cluster maintenance and troubleshooting tasks**
#### Table of Contents

1. [Cluster checks](#cluster-checks)
2. [Failure scenarious](#failure-scenarious)
3. [Useful links](#useful-links)

## Cluster checks

For the Galera cluster we will be using same Ansibe node we were using for the deployment, or each command can be ran on the separate cluster node using ssh connection

#### MySQL service status checking

`ansible --ssh-common-args='-o StrictHostKeyChecking=no' -i ./inventories/db_hosts_ulm.ini -b -a "/etc/init.d/mysql status" all`

Example output:

```
db4-pre.hki.management.id.telia.fi | SUCCESS | rc=0 >>
 SUCCESS! MariaDB running (15434)

db1-pre.hki.management.id.telia.fi | SUCCESS | rc=0 >>
 SUCCESS! MariaDB running (2114)

db1-pre.jkl.management.id.telia.fi | SUCCESS | rc=0 >>
 SUCCESS! MariaDB running (2845)

db3-pre.hki.management.id.telia.fi | SUCCESS | rc=0 >>
 SUCCESS! MariaDB running (7436)

db2-pre.hki.management.id.telia.fi | SUCCESS | rc=0 >>
 SUCCESS! MariaDB running (30416)

db2-pre.jkl.management.id.telia.fi | SUCCESS | rc=0 >>
 SUCCESS! MariaDB running (27445)

db3-pre.jkl.management.id.telia.fi | SUCCESS | rc=0 >>
 SUCCESS! MariaDB running (32747)

db4-pre.jkl.management.id.telia.fi | SUCCESS | rc=0 >>
 SUCCESS! MariaDB running (2101)

```
#### MySQL Galera cluster status checks

`ansible --ssh-common-args='-o StrictHostKeyChecking=no' -i ./inventories/db_hosts_ulm.ini -b -a "mysql -se \"show status like 'wsrep_cluster%'\"" all`

Example output:

```
db1-pre.hki.management.id.telia.fi | SUCCESS | rc=0 >>
wsrep_cluster_conf_id   21
wsrep_cluster_size      8
wsrep_cluster_state_uuid        be84ca57-3bda-11e8-a597-d73e0832980d
wsrep_cluster_status    Primary

db2-pre.hki.management.id.telia.fi | SUCCESS | rc=0 >>
wsrep_cluster_conf_id   21
wsrep_cluster_size      8
wsrep_cluster_state_uuid        be84ca57-3bda-11e8-a597-d73e0832980d
wsrep_cluster_status    Primary

db3-pre.hki.management.id.telia.fi | SUCCESS | rc=0 >>
wsrep_cluster_conf_id   21
wsrep_cluster_size      8
wsrep_cluster_state_uuid        be84ca57-3bda-11e8-a597-d73e0832980d
wsrep_cluster_status    Primary

```
All parameters should be the same on all nodes `wsrep_cluster_size` = Nodes count

`ansible --ssh-common-args='-o StrictHostKeyChecking=no' -i ./inventories/db_hosts_ulm.ini -b -a "mysql -se \"show status like 'wsrep_local_state%'\"" all`

Example output:

```
db4-pre.hki.management.id.telia.fi | SUCCESS | rc=0 >>
wsrep_local_state       4
wsrep_local_state_comment       Synced
wsrep_local_state_uuid  be84ca57-3bda-11e8-a597-d73e0832980d

db1-pre.hki.management.id.telia.fi | SUCCESS | rc=0 >>
wsrep_local_state       4
wsrep_local_state_comment       Synced
wsrep_local_state_uuid  be84ca57-3bda-11e8-a597-d73e0832980d

db3-pre.hki.management.id.telia.fi | SUCCESS | rc=0 >>
wsrep_local_state       4
wsrep_local_state_comment       Synced
wsrep_local_state_uuid  be84ca57-3bda-11e8-a597-d73e0832980d
```

#### Displaying all the Galera cluster information (better is to limit output to one node)

`ansible --ssh-common-args='-o StrictHostKeyChecking=no' -i ./inventories/db_hosts_ulm.ini -b -a "mysql -se \"show status like 'wsrep%'\"" db1*`

Example of succesfull output:

```
db1-pre.jkl.management.id.telia.fi | SUCCESS | rc=0 >>
wsrep_apply_oooe        0.001292
wsrep_apply_oool        0.000000
wsrep_apply_window      1.001292
wsrep_causal_reads      0
wsrep_cert_deps_distance        11.126649
wsrep_cert_index_size   23
wsrep_cert_interval     0.093668
wsrep_cluster_conf_id   35
wsrep_cluster_size      8
wsrep_cluster_state_uuid        be84ca57-3bda-11e8-a597-d73e0832980d
wsrep_cluster_status    Primary
wsrep_commit_oooe       0.000000
wsrep_commit_oool       0.000000
wsrep_commit_window     1.000000
wsrep_connected ON
wsrep_desync_count      0
wsrep_evs_delayed
wsrep_evs_evict_list
wsrep_evs_repl_latency  0/0/0/0/0
wsrep_evs_state OPERATIONAL
wsrep_flow_control_paused       0.000000
wsrep_flow_control_paused_ns    0
wsrep_flow_control_recv 0
wsrep_flow_control_sent 0
wsrep_gcomm_uuid        a973493e-4ecd-11e8-ac94-c26b1f2a31e7
wsrep_incoming_addresses        10.18.41.196:3306,10.18.41.199:3306,10.18.45.197:3306,10.18.45.198:3306,10.18.41.197:3306,10.18.45.196:3306,10.18.45.199:3306,10.18.41.198:3306
wsrep_last_committed    1205907
wsrep_local_bf_aborts   0
wsrep_local_cached_downto       1205149
wsrep_local_cert_failures       0
wsrep_local_commits     51
wsrep_local_index       5
wsrep_local_recv_queue  0
wsrep_local_recv_queue_avg      0.015131
wsrep_local_recv_queue_max      3
wsrep_local_recv_queue_min      0
wsrep_local_replays     0
wsrep_local_send_queue  0
wsrep_local_send_queue_avg      0.000000
wsrep_local_send_queue_max      1
wsrep_local_send_queue_min      0
wsrep_local_state       4
wsrep_local_state_comment       Synced
wsrep_local_state_uuid  be84ca57-3bda-11e8-a597-d73e0832980d
wsrep_protocol_version  7
wsrep_provider_name     Galera
wsrep_provider_vendor   Codership Oy <info@codership.com>
wsrep_provider_version  25.3.18(r3632)
wsrep_ready     ON
wsrep_received  727
wsrep_received_bytes    405842
wsrep_repl_data_bytes   25957
wsrep_repl_keys 158
wsrep_repl_keys_bytes   2552
wsrep_repl_other_bytes  0
wsrep_replicated        56
wsrep_replicated_bytes  32093
wsrep_thread_count      2

```
## Failure scenarious

1. One node is not operational due to system or hardware failure.
* Cluster state: OPERATIONAL
* Soultion: Cluster is working properly, MySQL service on the failed node can be started at once when it gets back.
2. Two nodes left in cluster.
* Cluster state: OPERATIONAL
* Soultion: Cluster is working properly, MySQL service can be started on the failed nodes at one they
3. Only one node left in cluster.
* Cluster state: BLOCKED (only USAGE commands are available on the node. Node is blocking all transactions in order to save consistency)
* Soultion: No special actions needed, cluster will start working properly at once it will get one more node alive.
4. Whole cluster was accidentaly shutdown or all the nodes loose connectivity
* Cluster state: FAILED (special BOOTSTRAP procedure needed, same as we are doing on the ne cluster)
* Soultion: We need to find a node having the latest transaction information it can be done by running command provided below:
`ansible --ssh-common-args='-o StrictHostKeyChecking=no' -i ./inventories/db_hosts_ulm.ini -b -a "cat /opt/uxp/mysql/grastate.dat" all`

Example command output will look like that:

```
db4-pre.hki.management.id.telia.fi | SUCCESS | rc=0 >>
# GALERA saved state
version: 2.1
uuid:    be84ca57-3bda-11e8-a597-d73e0832980d
seqno:   1206525
cert_index:

```
For the bootstrap we should select node having maximum `seqno` value. And then we can start it with command `/etc/init.d/mysql bootstrap`.
After node up and running we can start other nodes `/etc/init.d/mysql start`

* Possible issues: Sometimes it's not possible to determine last node. In this case we need to select one node and put line `safe_to_bootstrap 1` in the end of the grastate.dat. And then perform usual bootstrap procedure.

## Replication restore

Between MAIN and DR clusters we are using asynchronous master slave replication. In case of failure sometimes full DR site restore process is required. For doing that such actions need to be performed.

1. On Master node
* `show master status\G`
* Reply example:
```
*************************** 1. row ***************************
            File: galera_preprod_cluster-bin.000016
        Position: 55211683
    Binlog_Do_DB: mint_platform,mint_application_batch,mint_application_quartz
Binlog_Ignore_DB:

```
* `SELECT BINLOG_GTID_POS('galera_preprod_cluster-bin.000016', 55211683);`
* Reply example:
```
+----------------------------------------------------------------+
| BINLOG_GTID_POS('galera_preprod_cluster-bin.000016', 55211683) |
+----------------------------------------------------------------+
| 1-196-13812286                                                 |
+----------------------------------------------------------------+
```
* From command line:
```
mysqldump --single-transaction --quick --lock-tables=false --databases $(mysql -se "show databases" \
| grep mint | tr '\n' ' ' | sed  's/.$//') \
| gzip > mint_databases_backup_$(date +%Y%m%d).sql.gz \
&& chown hgb7542:hgb7542 mint_databases_backup_$(date +%Y%m%d).sql.gz
```
* Whith `scp` or some other tool we need to transfer this backup file to the DR site database server.

2. On Slave node
* As root user tun command `gunzip < BACKUP_FILE.sql.gz | mysql`
* From MySQL command line:
```
STOP SLAVE;
RESET SLAVE;
SET GLOBAL gtid_slave_pos = '1-196-13812286';
CHANGE MASTER TO master_use_gtid=slave_pos;
START SLAVE;

```

## Useful links
1. [Percona cluster restore documentation](https://www.percona.com/blog/2014/09/01/galera-replication-how-to-recover-a-pxc-cluster/)
2. [Galera documentation](http://galeracluster.com/documentation-webpages/)
