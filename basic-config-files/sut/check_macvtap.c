// Small program to test macvtap interfaces
// It assumes that
// * macvtap interface has IP address 172.16.17.18
//                         MAC        0E:0E:0E:0E:0E:0E
// * the following command has been issued:
//                   arping -c 1 -I macvtap1 172.16.0.1
// It then listens on /dev/tapX to check
// whether the correct answer was received.

#include <sys/types.h>
#include <dirent.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>

// Expected ARP packet
// -1 stands for unknown data
int arp_packet[70] = {
  0x00, 0x00, 0x00, 0x00, 0x00,        // 10 bytes preamble
  0x00, 0x00, 0x00, 0x00, 0x00,
  0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e,  // destination MAC address
    -1,   -1,   -1,   -1,   -1,   -1,  // source MAC address
  0x08, 0x06,                          // ARP protocol
  0x00, 0x01, 0x08, 0x00, 0x06, 0x04,  // Ethernet <=> IP
  0x00, 0x02,                          // "is at" answer
    -1,   -1,   -1,   -1,   -1,   -1,  // source MAC address
   172,   16,    0,    1,              // source IP address
  0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e,  // destination MAC address
   172,   16,   17,   18,              // destination IP address
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // 18 bytes postamble
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00
};

// macvtap file name
char fn[16];

// Read buffer
unsigned char buffer[70];              

// Search for /dev/tapX
void search_tap()
{
  char *hint = "/sys/class/net/macvtap1/ifindex";
  FILE *fp = fopen(hint, "r");
  int index;

  if (fp == NULL)
  {
    printf("Can't open %s\n", hint);
    exit(-1);
  }
  fscanf(fp, "%d", &index);
  fclose(fp);

  snprintf(fn, 15, "/dev/tap%d", index);
  fn[15] = '\0';
}

// Read 70 bytes from the tap device
void read_packet()
{
  int fd;

  fd = open(fn, O_RDONLY);
  if (fd == -1)
  {
    printf("Can't open tap device %s\n", fn);
    exit(-2);
  }
  if (read(fd, &buffer, 70) != 70)
  {
    printf("Error reading %s\n", fn);
    close(fd);
    exit(-3);
  }
  close(fd);
}

// Analyze those 70 bytes
void analyze_packet()
{
  unsigned char *pbuffer;
  int *ppacket;

  for (ppacket = arp_packet, pbuffer = buffer;
       ppacket < arp_packet + 70;
       ppacket++, pbuffer++)
  {
     if (*ppacket != -1)
     {
       if (*pbuffer != *ppacket)
       {
         printf("Not received the expected packet\n");
         exit(-4);
       }
     }
  }
  printf("Success listening to tap device %s, received the expected ARP packet\n", fn);
}

// Main program
int main()
{
  search_tap();
  read_packet();
  analyze_packet();

  return 0;
}
