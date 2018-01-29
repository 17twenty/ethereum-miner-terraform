# Ethereum CUDA Miner - Terraform Setup

Ready to deploy terraform based deployment of CUDA Ethereum miner.

It uses the [Deep Learning AMI for Ubuntu 1604](https://aws.amazon.com/about-aws/whats-new/2017/07/aws-deep-learning-ami-for-ubuntu-now-available-with-cuda-8--ubuntu-16-and-latest-versions-of-deep-learning-frameworks/)
but you can swap that out if need be.

This whole project is a one stop shop to deploying an Ethereum mining setup on the AWS platform.

You can use this as needed - ideally you'd use it to setup some GAS expenditure/cool smart apps. Don't just HODL.

_Note:_ As with anything on the internet - verify this does what you want rather than getting angry about free stuff.
You can replace ethminer if you want or just verify the checksum is the same as the official binary yourself.

## Getting Started

Get Terraform. Get your creds. Run this:

```bash
$ terraform init
$ terraform apply -var 'aws_access_key_id=XX'  -var 'aws_secret_access_key=XX' -var 'count=2' -var 'wallet_address=0xYOURADDRESSHERE'
...
Apply complete! Resources: 4 added, 4 changed, 0 destroyed.

Outputs:

ip_addresses-heavy = X.X.X.X
ip_addresses-light =  X.X.X.X
$ ssh -i provisioner/keys/aws_terraform ubuntu@X.X.X.X
ubuntu@ip-X-X-X-X:~$
```

Obviously tweak as needed - `count` is how many instance of each type to spin up, `wallet_address` is your address to send coins too.

It uses [dwarfpool](https://dwarfpool.com/eth) by default - it was easy - to verify your account, in the box for your wallet it will specify a hint
for example mine said [ ..*.116 ] just look for the ip that ends the same as the hint gives you. When you specify that, you got options.

## Donations

For meee? If you insist on sending me ETH, that'd be awesome - 0x7ea397225ebd5c56afc26cb3bfa4fe994a60f106
It's the default wallet as well so feel free to run that for like, a month as an alternative payment :P

## Tear down

```bash
$ terraform destroy -var 'aws_access_key_id=XX'  -var 'aws_secret_access_key=XX' -var 'count=2' -var 'wallet_address=0xYOURADDRESSHERE'
...
```

## Replacing the keys

> I hate your keys, I wanna change them

Yeah - alright mate! Jeez, no skin off my nose. Just do this:

```bash
$ ssh-keygen -q -f keys/aws_terraform -C aws_terraform_ssh_key -N ''
...
```

### How's it going?

If you have got keys uploaded then you can check how things are going by SSHing in and using `journalctl`

```bash
$ journalctl -u eth -f
Jan 25 07:53:06 ip-X-X-X-X ethminer[1650]:   m  07:53:06|ethminer  Speed   4.35 Mh/s    gpu/0  4.35  [A0+0:R0+0:F0] Time: 00:01
Jan 25 07:53:07 ip-X-X-X-X ethminer[1650]:   m  07:53:07|ethminer  Speed   4.35 Mh/s    gpu/0  4.35  [A0+0:R0+0:F0] Time: 00:01
Jan 25 07:53:07 ip-X-X-X-X ethminer[1650]:   m  07:53:07|ethminer  Speed   4.33 Mh/s    gpu/0  4.33  [A0+0:R0+0:F0] Time: 00:01
Jan 25 07:53:08 ip-X-X-X-X ethminer[1650]:   m  07:53:08|ethminer  Speed   4.33 Mh/s    gpu/0  4.33  [A0+0:R0+0:F0] Time: 00:01
Jan 25 07:53:08 ip-X-X-X-X ethminer[1650]:   m  07:53:08|ethminer  Speed   4.43 Mh/s    gpu/0  4.43  [A0+0:R0+0:F0] Time: 00:01
Jan 25 07:53:09 ip-X-X-X-X ethminer[1650]:   m  07:53:09|ethminer  Speed   4.43 Mh/s    gpu/0  4.43  [A0+0:R0+0:F0] Time: 00:01
...
```
