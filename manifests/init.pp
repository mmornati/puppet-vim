class vim {

    $el4pkgs = [  'vim-common', 'vim-enhanced', 'vim-X11' ]

    $el5pkgs = [  'vim-common', 'vim-enhanced', 'vim-X11',
                  'ctags', 'gcc', 'make', 'ruby-devel', 'ack', 'git',
                  'dejavu-fonts-common', 'dejavu-sans-mono-fonts' ]

    $el6pkgs = [  'vim-common', 'vim-enhanced', 'vim-X11',
                  'ctags', 'gcc', 'make', 'ruby-devel', 'ack', 'git',
                  'dejavu-fonts-common', 'dejavu-sans-mono-fonts',
                  'libcanberra-gtk2', 'flake8' ]

    $debpkgs = [  'vim-common', 'vim', 'vim-gtk', 'exuberant-ctags', 'gcc',
                  'make', 'ruby1.8-dev', 'ack-grep', 'git',
                  'ttf-dejavu-core', 'ttf-dejavu-extra',
                  'libcanberra-gtk-module' ]

    if $::osfamily == 'Debian' { package { $debpkgs : ensure => installed } }
    else {
        include yum
        case $::operatingsystemrelease {
            default : { package { $el4pkgs :
                          ensure  => installed } }
            /^5\./  : { package { $el5pkgs :
                          ensure  => latest ,
                          require => File[ '/etc/yum.repos.d/custom.repo' ] } }
            /^6\./  : { package { $el6pkgs :
                          ensure  => latest,
                          require => File[ '/etc/yum.repos.d/custom.repo' ] } }
        }
    }

    $vimrep = $::osfamily ? {
        'Debian' => 'vim',
        default  => 'vim-enhanced',
    }

    file { '/etc/vimrc' :
        ensure   => present,
        owner    => 'root',
        group    => 'root',
        mode     => '0644',
        source   => 'puppet:///modules/vim/vimrc',
        require  => Package[ $vimrep ],
    }

}

