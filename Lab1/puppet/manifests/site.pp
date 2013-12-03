package {'roundhouse':
  ensure => latest,
  provider => chocolatey,
  source => 'c:\vagrant\resources\packages',
}

# package {'poshgit':
#   ensure => latest,
#   provider => chocolatey,
# }
