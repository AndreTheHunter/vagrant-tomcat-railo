
service { 'tomcat7':
  ensure => 'running',
  enable => true,
}

file { '/etc/tomcat7/server.xml':
  owner  => 'tomcat7',
  group  => 'tomcat7',
  mode   => '0644',
  source => '/vagrant/conf/server.xml',
  notify => Service['tomcat7'],
}

file { '/etc/tomcat7/web.xml':
  owner  => 'tomcat7',
  group  => 'tomcat7',
  mode   => '0644',
  source => '/vagrant/conf/web.xml',
  notify => Service['tomcat7'],
}

file { 'catalina.properties':
  name   => '/etc/tomcat7/catalina.properties',
  owner  => 'tomcat7',
  group  => 'tomcat7',
  mode   => '0644',
  source => '/vagrant/conf/catalina.properties',
  notify => Service['tomcat7'],
}

file { ['/var/lib/tomcat7/webapps/railo',
  '/var/lib/tomcat7/webapps/railo/WEB-INF',
  '/var/lib/tomcat7/webapps/railo/WEB-INF/lib',
  '/var/lib/tomcat7/webapps/railo/WEB-INF/lib/railo-server',
  '/var/lib/tomcat7/webapps/railo/WEB-INF/lib/railo-server/context'] :
  ensure => 'directory',
  owner  => 'tomcat7',
  group  => 'tomcat7',
}

file { 'railo-server.xml':
  name    => '/var/lib/tomcat7/webapps/railo/WEB-INF/lib/railo-server/context/railo-server.xml',
  owner   => 'tomcat7',
  group   => 'tomcat7',
  source  => '/vagrant/conf/railo-server.xml',
  mode    => '0644',
  require => File['/var/lib/tomcat7/webapps/railo/WEB-INF/lib/railo-server/context'],
  notify  => Service['tomcat7'],
}

#file { 'default.tomcat7':
# name  => '/etc/default/tomcat7',
# owner => 'root',
# group => 'root',
# mode  => 644,
# notify  => Service['tomcat7'],
# content => 'JAVA_OPTS="-Djava.awt.headless=true -Xmx1024m -Xms256m -XX:+UseConcMarkSweepGC"'
#}

file { 'setenv.sh':
  name    => '/usr/share/tomcat7/bin/setenv.sh',
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  notify  => Service['tomcat7'],
  content => 'JAVA_OPTS="-Xms128m -Xmx1024m -XX:MaxPermSize=384m -javaagent:webapps/railo/WEB-INF/lib/railo-inst.jar";
export JAVA_OPTS;'
}

file { 'ntp.conf':
  name    => '/etc/ntp.conf',
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  notify  => Service['tomcat7'],
  content => '
    server 192.168.100.5
    server ntp2.pipex.net
    server ntp1.pipex.net
'
}
