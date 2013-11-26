define gitdeploy::repo(
  $repoName = $name
) {
    $gitpath = "${gitdeploy::bareReposDir}/${repoName}.git"
    $webpath = "${gitdeploy::webroot}/${repoName}"

    file { "${webpath}":
        ensure => "directory",
        owner    => "${gitdeploy::owner}",
        group   => "${gitdeploy::group}",
    }

    file { "${gitpath}":
        ensure => "directory",
        owner    => "${gitdeploy::owner}",
        group   => "${gitdeploy::group}",
    }
    ->
    exec { "git init --bare ${gitpath}":
        path    => "/usr/bin",
        user    => "${gitdeploy::owner}",
        group   => "${gitdeploy::group}",
        unless  => "test -f ${gitpath}/hooks",
    }
    ->
    file { "${gitpath}/hooks/update":
        content => template('gitdeploy/update.sh'),
        replace => "true",
        owner   => "${gitdeploy::owner}",
        group   => "${gitdeploy::group}",
        mode    => 777,
    }
}
