class gitdeploy (
    $bareReposDir,
    $webroot,
    $owner,
    $group
) {
    #require Package["git-core"]

    file { "${bareReposDir}":
        ensure => "directory",
        owner   => "${owner}",
        group   => "${group}"
    }


    file { "${webroot}":
        ensure => "directory",
        owner   => "${owner}",
        group   => "${group}"
    }
}
