#! /usr/bin/env ruby

require "twopence"
require "fileutils"

#######################################################################
# Adapt the following line to your setup
#   $target = Twopence::init("virtio:/var/run/twopence/test.sock")
#   $target = Twopence::init("ssh:192.168.123.45")
#   $target = Twopence::init("serial:/dev/ttyS0")
$target = Twopence::init(ENV["TARGET_REF"])
#######################################################################

# This is the clean way to process interrupted twopence commands
#trap("INT") { $target.interrupt_command(); exit() }
#end
def copyRefFiles()
puts("Copying ifcg and other cfg files to REF...")
  Dir.entries('images-config/files-ref').each do |file|
    next if File.directory? file
    local, remote = $target.inject_file("/var/lib/jenkins/wicked-testsuite/images-config/files-ref/#{file}", "/etc/sysconfig/network/pool/#{file}")
 end
end
# We can send a command to the system under tests
#printf("\nlocal, remote, command = $target.test_and_print_results('ls -l')\n")
#local, remote, command = $target.test_and_print_results('ls -l')
#printf("local=%d remote=%d command=%d\n\n", local, remote, command)

=begin
# This is a quick fix for copying ifcg files to REF without relaying on a new image build
# Copy REF files to vm
  puts("Copying ifcg and other cfg files to REF...")
  Dir.entries('images-config/files-ref').each do |file|
    next if File.directory? file
    local, remote, command = $target.inject_file \
    "/var/lib/jenkins/wicked-testsuite/images-config/files-ref/#{file}", "/etc/sysconfig/network/pool/#{file}", \
    "root", false
#    local.should == 0; remote.should == 0; command.should ==0
  end
=end
