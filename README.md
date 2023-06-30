# Launchpad Solidity Kontratı

Bu projede, bir ERC20 tokeni oluşturan ve önsatışları yöneten bir Ethereum akıllı kontratı bulunmaktadır.

## Nasıl Çalışır?

1. **Kontrat oluşturulduğunda**, ilk token oluşturulur ve admin belirlenir. Tokenin adı, sembolü ve başlangıç arzı kontrat oluşturulurken belirlenir.

2. **Admin**, `startPresale` fonksiyonunu kullanarak bir önsatış başlatabilir. Bu fonksiyon, tokenin fiyatını, satışa sunulacak token miktarını (arzın belirli bir yüzdesi olarak) ve satışın ne zaman biteceğini belirler.

3. **Kullanıcılar**, `buyTokens` fonksiyonunu kullanarak önsatışta token satın alabilirler. Satın alınan token miktarı, kullanıcının gönderdiği Ether miktarına göre belirlenir.

4. **Önsatış sona erdikten sonra**, kullanıcılar `claimTokens` fonksiyonunu kullanarak tokenlarını talep edebilirler. Talep edilen tokenlar, kullanıcının adresine transfer edilir.

