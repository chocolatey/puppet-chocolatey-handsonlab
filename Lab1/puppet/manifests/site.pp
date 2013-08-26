 package {'roundhouse':
  ensure => latest,
  provider => 'chocolatey',
  source => 'c:\vagrant\resources\packages',
}