# A Home Server in the Country: OpenBSD, Fixed Wireless, and Cloudflared

[John Inman](/)

2026-09-20

[Author's note: all em-dashes are my own.]

## Goal

The goal of this project is to serve a personal website from a home.

## Constraints

1. Small (no) budget
2. Server must run OpenBSD
3. Home network is behind a carrier-grade NAT (CGN)

## Approach

The budget for this project is small to non-existent. Fortunately, the
necessary components have accreted over time due to a consistency of interests
and the sustained passage of time: I have in my possession an old Lenovo T440s
laptop, once a prized possession, now thicker and less refined than I
remember, that nontheless offers an energy efficient x86 cpu and ethernet
port; a custom domain rented from the registrar for the equivalent of bus fare
every month; and an internet connection I pay dearly for, but am nonethesless
grateful for, it being my connection to the office 3 days a week in a place
where I can barely hear road noise. 

### OpenBSD

I first heard of OpenBSD from my boss---he was well into his current career as
an [agister](https://www.google.com/search?q=define+agister). His past career,
I'm not sure how many there had been, had been in "tech". He still freelanced.
Once he left his laptop open on a table in the barn. The screen was full of
deliberately indented dollars signs, curly brackets, and letters, most of
which hinted at but did not spell actual words. I was quite enchanted. I would
ask him for stories about the machines called computers. He told me the
requisite stories about punch cards. He also told me about OpenBSD. He used to
work in security. OpenBSD was INSANE about security. This gave it an aura of a
mythical bronco. If somehow you could tame the beast, and ride it...unlimited
powers would be yours. 

It is somewhat surprising that OpenBSD is actually one of the sturdiest and
most straightforward open source operating systems you can use---if it
supports your hardware... and software. I don't have a practical need for it.
I use it because it's polish is a sure sign that someone put care into, and it
is a joy to use. And I trust it to sit unattended on my server and
run...indefinitely...without intervention. (So far, so good, except when the
power goes out). 

### Fixed Wireless and CGN

But there is always a price, and today the price is that we must tunnel
through a CGN. My ISP bounces signal to my house from a hill top a couple
miles away. That device on the hill has a public IP address. I do not. My ISP
generously offered a static IP at $10/mo. (they are limited and costly to
obtain, to be sure) but, most helpfully, also told me about Cloudflared
tunnels. The catch, Cloudflared is not _officially_ supported on OpenBSD. But
this is open source software, and I have Claude.

### Cloudflared

Behold, [ivoronin](https://github.com/ivoronin/openbsd-port-cloudflared) has
been up to much of the same and has developed some patches for (2026.7.0)
Cloudflared. For whatever reason, it is setup as an unofficial port entry,
and, for whatever reason, the X11 window system was a dependency for working
with ports, which did not suite my headless server, so I downloaded the
[pinned release](https://github.com/cloudflare/cloudflared/archive/refs/tags/2026.7.0.tar.gz), 
borrowed his
[patches](https://github.com/ivoronin/openbsd-port-cloudflared/tree/main/patches)
and applied them myself:

```
patch -p0 < patch-diagnostic_network_collector_unix_go
patch -p0 < patch-Makefile
patch -p0 < patch-diagnostic_system_collector_openbsd_go
```

That last one is quite long and it would be interesting to know exactly what
is going on there. Interestingly, these patches are insufficient to build the
latest release; it seems the Cloudflare team has been busy adding new
features...that also need to be patched to run on OpenBSD. Saving for a rainy
day...

Once patched, it can be built (using gmake!), and installed:

```
gmake cloudflared
install -m 755 cloudflared /usr/local/bin/cloudflared
```

No run with

```
cloudflared tunnel login
cloudflared tunnel create <tunnel>
cloudflared tunnel route dns <tunnel> <domain>
```

Edit `/etc/rc.d/cloudflared` to make persistent:


```
#!/bin/ksh

daemon="/usr/local/bin/cloudflared"
daemon_flags="tunnel --config /etc/cloudflared/config.yml run"
daemon_user="jfin"

. /etc/rc.d/rc.subr

rc_bg=YES
rc_reload=NO

rc_cmd $1

```

and run:

```
chmod +x /etc/rc.d/cloudflared
rcctl enable cloudflared
rcctl start cloudflared
```

Finally, there is some dashboarding to with a (free) Cloudflare account. 
Change nameserver in your registrar setting (in my case, Namecheap), and tell
Cloudflare to always use HTTPS (under Cloudflare Edge Certificates).

## Conclusion

If you are reading this, it is working.

[Edit this page on GitHub](https://github.com/jfin4/jfin.net/edit/main/content/2026-09-20/home-server.md)
