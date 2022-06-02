import 'UserController.dart';
import 'package:myapp/models/database.dart';
import 'package:myapp/models/product.dart';

class CoopHeadController extends UserController {



    viewAuctionTables() {
        //Bunun için zaten ayrı sayfa var
        // TODO: implement changeProductFlow
        throw UnimplementedError();
    }

    void changeProductFlow() {
        //Şimdi db yi product ın içince import

      // TODO: implement changeProductFlow
      throw UnimplementedError();
    }

    changeBasePrice() {
        //Bu fonksiyon için product importlanmalı,product database den veriyi alacak yani onun içinde db importu var variable lara eşitleyecek
        //Sonra product instance ından çekilen basePrice kısmı değiştirilecek
        // TODO: implement changeProductFlow
        throw UnimplementedError();
    }

    finishLiveAuction() {
        //Live auction sayfasından navigasyon ile ana ekrana atacak
        //Alttaki gibi bi kod düşündüm
        //Sadece db ye yansıması var
        //Daha sonra biten auction bitmiş olarak bool bir variable ile marklanıp db.ref().child('Finished Auctions').push(Auctions[AuctionID])
        // TODO: implement changeProductFlow
        throw UnimplementedError();
    }

    activateDeactivateButtons(){
        //Bu direk flatbutton üstünü çizecek,buna basılacak sonra bi pop up çıkacak,aktive etmek istediğin butonun ismini gir gibi
        //Aslında activate ve deactivate tek bi buton çıkan pop up içinde iki seçenek olsun,activate ve deactivate diye onlardan birine basılınca buton adı
        //Buton ların adları gelsin ekrana ve seçilen buton deaktive olsun ya da aktive olsun,
        // TODO: implement changeProductFlow
        throw UnimplementedError();
    }

    finaliseSoldPrice(){
        //? Kafam durdu
        // TODO: implement changeProductFlow
        throw UnimplementedError();
    }


}

