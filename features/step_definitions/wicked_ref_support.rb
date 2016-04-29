#! /usr/bin/env ruby

require "twopence"
require "fileutils"

$target = Twopence::init(ENV["TARGET_REF"])
#######################################################################
puts("Copying ifcg and other cfg files to REF...")
def copyRefFiles()
  Dir.entries('images-config/files-ref').each do |file|
    next if File.directory? file
    local, remote = $target.inject_file("/var/lib/jenkins/wicked-testsuite/images-config/files-ref/#{file}", "/etc/sysconfig/network/pool/#{file}")
 end
end
