# Demo for checking host package dependencies from a privileged container

## Start container with missing dependencies

```
[root@scsor0005398001 plugins-dep]# docker-compose up
Starting pluginsdep_ndvp-server_1
Attaching to pluginsdep_ndvp-server_1
ndvp-server_1  | This plugin is dependent on several packages that are missing
ndvp-server_1  | on the redhat-based host system:
ndvp-server_1  |
ndvp-server_1  |  >  nfs-utils lsscsi
ndvp-server_1  |
ndvp-server_1  | Please install them, or re-run this plugin with -i to try to
ndvp-server_1  | install them automatically.
pluginsdep_ndvp-server_1 exited with code 0
```

## Add `-i` to invocation
```
[root@scsor0005398001 plugins-dep]# docker-compose up
Starting pluginsdep_ndvp-server_1
Attaching to pluginsdep_ndvp-server_1
ndvp-server_1  | Starting install using 'yum' for the following packages:
ndvp-server_1  | nfs-utils lsscsi
ndvp-server_1  | Loaded plugins: fastestmirror, langpacks
ndvp-server_1  | Loading mirror speeds from cached hostfile
ndvp-server_1  |  * base: mirrors.mit.edu
ndvp-server_1  |  * extras: centos.mirror.constant.com
ndvp-server_1  |  * updates: mirror.steadfast.net
ndvp-server_1  | Resolving Dependencies
ndvp-server_1  | There are unfinished transactions remaining. You might consider running yum-complete-transaction, or "yum-complete-transaction --cleanup-only" and "yum history redo last", first to finish them. If those don't work you'll have to try removing/installing packages by hand (maybe package-cleanup can help).
ndvp-server_1  | --> Running transaction check
ndvp-server_1  | ---> Package lsscsi.x86_64 0:0.27-3.el7 will be installed
ndvp-server_1  | ---> Package nfs-utils.x86_64 1:1.3.0-0.21.el7_2.1 will be installed
ndvp-server_1  | --> Finished Dependency Resolution
ndvp-server_1  |
ndvp-server_1  | Dependencies Resolved
ndvp-server_1  |
ndvp-server_1  | ================================================================================
ndvp-server_1  |  Package         Arch         Version                       Repository     Size
ndvp-server_1  | ================================================================================
ndvp-server_1  | Installing:
ndvp-server_1  |  lsscsi          x86_64       0.27-3.el7                    base           47 k
ndvp-server_1  |  nfs-utils       x86_64       1:1.3.0-0.21.el7_2.1          updates       371 k
ndvp-server_1  |
ndvp-server_1  | Transaction Summary
ndvp-server_1  | ================================================================================
ndvp-server_1  | Install  2 Packages
ndvp-server_1  |
ndvp-server_1  | Total size: 418 k
ndvp-server_1  | Installed size: 1.1 M
ndvp-server_1  | Downloading packages:
ndvp-server_1  | Running transaction check
ndvp-server_1  | Running transaction test
ndvp-server_1  | Transaction test succeeded
ndvp-server_1  | Running transaction
ndvp-server_1  | Warning: RPMDB altered outside of yum.
  Installing : lsscsi-0.27-3.el7.x86_64                                     1/2
  Installing : 1:nfs-utils-1.3.0-0.21.el7_2.1.x86_64                        2/2
  Verifying  : 1:nfs-utils-1.3.0-0.21.el7_2.1.x86_64                        1/2
  Verifying  : lsscsi-0.27-3.el7.x86_64                                     2/2
ndvp-server_1  |
ndvp-server_1  | Installed:
ndvp-server_1  |   lsscsi.x86_64 0:0.27-3.el7        nfs-utils.x86_64 1:1.3.0-0.21.el7_2.1
ndvp-server_1  |
ndvp-server_1  | Complete!
ndvp-server_1  | [Add real nDVP binary here]
ndvp-server_1  | Invoked with: --in-container=true --config=http://10.193.45.241/dvp_config --debug
pluginsdep_ndvp-server_1 exited with code 0
```

## Example of running on a system that is not recognized
```
[root@scsor0005398001 plugins-dep]# docker-compose up
Starting pluginsdep_ndvp-server_1
Attaching to pluginsdep_ndvp-server_1
ndvp-server_1  |
ndvp-server_1  | Couldn't determine how to manage packages on this distribution.  This plugin has
ndvp-server_1  | host dependencies that need to be satisfied for it to work correctly.  For example,
ndvp-server_1  |   redhat-based: nfs-utils lsscsi iscsi-initiator-utils sg3_utils device-mapper-multipath
ndvp-server_1  |   debian-based: nfs-common open-iscsi lsscsi sg3-utils multipath-tools scsitools
ndvp-server_1  |
ndvp-server_1  | [Add real nDVP binary here]
ndvp-server_1  | Invoked with: --in-container=true --config=http://10.193.45.241/dvp_config --debug
pluginsdep_ndvp-server_1 exited with code 0
```

