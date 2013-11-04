# railo.pp

exec { 'apt-get':
	command	=> '/usr/bin/apt-get update',
}

/* get htop */
package { 'htop': 
	ensure	=> present,
	require	=> Exec['apt-get'],
}

package { 'curl': 
	ensure	=> present,
	require	=> Exec['apt-get'],
}

/* add cp2 to to the hosts file */
host { 'cp2.retailcloud.net':
	ip	=> '127.0.0.1',
}


/* nginx proxy pointing to tomcat on 8080 */
class { 'nginx': }
nginx::resource::upstream { 'railo':
	ensure	=> present,
	members	=> [
		'localhost:8080',
	],
}

/* nginx vhost using proxy + self signed ssl */
nginx::resource::vhost { 'cp2.retailcloud.net':
	ensure		=> present,
	proxy		=> 'http://railo',
	ssl			=> true,
	ssl_cert	=> '/vagrant/conf/server.crt',
	ssl_key		=> '/vagrant/conf/server.key',
	ssl_port	=> 443,
}

/* step 1 - make sure tomcat is installed as a default */
package {'tomcat7':
	ensure	=> installed,
	require	=> Package['curl'],
}

/* once tomcat is installed, update the server.xml, web.xml and catalina.properties */
exec { 'curl':
	name		=> '/usr/bin/curl localhost:8080',
	require		=> File['railo.war'],
	notify		=> Service['tomcat7'],
}

service { 'tomcat7':
	ensure  => 'running',
	enable  => 'true',
}

/* stick the railo war file into tomcat */
file { 'railo.war':
	name	=> '/var/lib/tomcat7/webapps/railo.war',
	owner	=> 'tomcat7',
	group	=> 'tomcat7',
	source	=> '/vagrant/conf/railo.war',
	require	=> Package['tomcat7'],
}
