# はじめに

docker-composeで起動後、以下のようにL2TPの設定を行います
主にコンテナ内でvpncmdを用いて行います
https://dev.classmethod.jp/articles/rk-2018-02-12-softethervpn/

主に上の手順の丸パクリですが、記事があぼーんされても辛い思いをしないようにここに書き残します

* 管理者パスワードを設定します

```bash
VPN Server> ServerPasswordSet 【管理者パスワード】
```

* VPN用の仮想HUBを追加します

```bash
HubCreate 【仮想HUB名】
HubCreate command - Create New Virtual Hub
Please enter the password. To cancel press the Ctrl+D key.

Password: 【管理者パスワード】
Confirm input: 【管理者パスワード】 # 2回入力する

The command completed successfully.
```

* 仮想HUBにユーザを追加します

ユーザは仮想HUB単位で管理されます。仮想HUBにユーザを追加してください。  
⭐︎のついた情報は必須です。必須以外の情報を入力したくない場合は、noneを選択してください

入力すべき情報

* USERID⭐︎
* GROUP
* REALNAME
* NOTE
* PASSWORD⭐︎

```bash
VPN Server> Hub VPN # 先ほど作った仮想HUBに接続。仮にVPNとする
VPN Server/VPN> UserCreate 【USERID】 /Group:【GROUP】 /REALNAME:【REALNAME】 /NOTE:【NOTE】
VPN Server/VPN> UserPasswordSet 【USERID】
UserPasswordSet command - Set Password Authentication for User Auth Type and Set Password
Please enter the password. To cancel press the Ctrl+D key.

Password: 【PASSWORD】
Confirm input: *********** # 2回入力する


The command completed successfully.
```

## IPSec有効化

IPSecを有効化する。

```bash
VPN Server>IPsecEnable /L2TP:yes /L2TPRAW:no /ETHERIP:no /DEFAULTHUB:VPN
IPsecEnable command - Enable or Disable IPsec VPN Server Function
Pre Shared Key for IPsec (Recommended: 9 letters at maximum): password

The command completed successfully.
```

## SecureNAT Enable

SecureNATを有効化する。

```bash
VPN Server/VPN>SecureNatEnable
SecureNatEnable command - Enable the Virtual NAT and DHCP Server Function (SecureNat Function)
The command completed successfully.
```

## Routing

```bash
VPN Server/VPN>Dhcpset /Start:192.168.30.10 /End:192.168.30.200 /Mask:255.255.255.0 /Expire:7200 /GW:192.168.30.1 /DNS:192.168.30.1 /DNS2:none /Domain:none /Log:yes /PushRoute:"10.0.0.0/
255.255.0.0/192.168.30.1"
DhcpSet command - Change Virtual DHCP Server Function Setting of SecureNAT Function
The command completed successfully.
```

以上で、VPNサーバに指定したユーザで接続できるようになっているはず。