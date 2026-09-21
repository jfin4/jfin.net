# A Home Server in the Country: OpenBSD, Fixed Wireless, and Cloudflared

[John Inman](/)

2026-09-20

## Introduction

I would like to host a personal website on a home server running OpenBSD from
behind a carrier-grade NAT (CGN). The problem is that pointing a custom domain
name to a home server requires a public IP address; fixed wireless ISPs
(WISP), who bounce signal to otherwise hard to reach customers, often
translate a single, public IP adress to many private, customer IPs via CGN.
I could point a domain name to the WISP's public IP, but the WISP would
have no way of knowing which private IP to route the request to.

A Cloudflare tunnel solves this problem. Instead of pointing a domain name
directly to the server, it points to Cloudflare instead. Cloudflare then
passes the request on to the server. It is able to do this because 1) I have
told the domain registrar to use Cloudflare's DNS servers, and 2) I have
created a tunnel to Cloudflare by running a persistent `cloudflared` process
on the server.

A caveat: OpenBSD is not officially supported by the Cloudflare tunnel client.
That's okay. It's an open-source project written in Go and can be minimally
patched to build on OpenBSD.

## Requirements

1. An old laptop
2. A domain name
3. A (free) Cloudflare account

## Steps

1. Download cloudflared patches. [Ilya
   Voronin](https://github.com/ivoronin/openbsd-port-cloudflared) has already
   done the hard work (thank you). The patch instructions target the OpenBSD
   ports tree; working with ports seems to require X11 (?). This is a headless
   server, so I just borrowed the patches and downloaded the cloudflared
   source directly. 

2. Download cloudflared source.  Note that, at the time I downloaded the
   patches they were targetting the [2026.7.0 cloudflared
   release](https://github.com/cloudflare/cloudflared/archive/refs/tags/2026.7.0.tar.gz).

3. Apply the patches:

   ```
   patch -p0 < patch-diagnostic_network_collector_unix_go
   patch -p0 < patch-Makefile
   patch -p0 < patch-diagnostic_system_collector_openbsd_go
   ```

   Also note, these patches are no longer sufficient for the current release
   (Cloudflare devs seem quite active). 

4. Once patched, it can be built and installed. Note, [cloudflared
   requires](https://github.com/cloudflare/cloudflared#requirements) GNU make
   (as well as capnproto and, obviously, go) so we use `gmake` instead of the
   `make` that comes with OpenBSD. 

   ```
   gmake cloudflared
   install -m 755 cloudflared /usr/local/bin/cloudflared
   ```

5. Set up the tunnel.

   ```
   cloudflared tunnel login
   cloudflared tunnel create <TUNNEL NAME>
   cloudflared tunnel route dns <TUNNEL NAME> <YOUR DOMAIN>
   ```

   To make persistent, edit `/etc/rc.d/cloudflared`:

   ```
   #!/bin/ksh

   daemon="/usr/local/bin/cloudflared"
   daemon_flags="tunnel --config /etc/cloudflared/config.yml run"
   daemon_user="<USER>"

   . /etc/rc.d/rc.subr

   rc_bg=YES
   rc_reload=NO

   rc_cmd $1

   ```

   and enable/start:
   
   ```
   chmod +x /etc/rc.d/cloudflared
   rcctl enable cloudflared
   rcctl start cloudflared
   ```

6. Update the registrar (in theis case, Namecheap) to use the nameservers
   provided by Cloudflare.

7. Bonus: tell Cloudflare to always use HTTPS (the option is under the
   Cloudflare Edge Certificates of the Cloudflare dashboard's navigation
   panel).

## Conclusion

If you are reading this, it is working 😉.

[Edit this page on GitHub](https://github.com/jfin4/jfin.net/edit/main/content/2026-09-20/home-server.md)
