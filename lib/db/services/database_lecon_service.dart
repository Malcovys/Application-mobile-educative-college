import '../dao/dao_factory.dart';
import '../dao/lecon_dao.dart';

import '../../models/lecon_model.dart';

class DatabaseLeconService {
  static late LeconDao _leconDao;
  
  static void initialize() {
    final DaoFactory daoFactory = DaoFactory();
    _leconDao = daoFactory.getLeconDao();
  }

  static Future<void> storeOneLeconFromAPI(Map<String, Object?> data) async {
    await _leconDao.storeOne(LeconModel.fromJson(data));
  }

  static Future<void> storeMultipleLeconsFormAPI(List<Map<String, Object?>> data) async {
    List<LeconModel> toStoredChapitres = [];
    
    for(var element in data) {
      toStoredChapitres.add(LeconModel.fromJson(element));
    }

    await _leconDao.storeMultiple(toStoredChapitres);
  }

  
  static Future<LeconModel?> getStoredLeconById(int id) async {
    return await _leconDao.selectOne(id);
  }

  static Future<List<LeconModel>> getStoredLeconsOfChapitre(int id) async {
    return await _leconDao.selectByChapitre(id);
  }
  

  static Future<void> removeStoredLecon(int id) async {
    await _leconDao.delete(id);
  }


  static Future<void> seed() async {
    await _seedChapitres();
  }

  static Future<void> _seedChapitres() async {
    List<LeconModel> chapitres = [];

    chapitres.addAll([
      LeconModel.fromJson({
        'id': 1, 
        'chapitre_id': 1,
        'titre': '',
        'contenu': '', 
        'created_at': DateTime.now(),
        'updated_at': DateTime.now()
      }),
        LeconModel.fromJson({
        'id': 2, 
        "chapitre_id": 1,
        'titre': '',
        'contenu': '',
        'created_at': DateTime.now(),
        'updated_at': DateTime.now()
      }),
      LeconModel.fromJson({
        'id': 2, 
        'chapitre_id': 1,
        'titre': '',
        'contenu': '', 
        'created_at': DateTime.now(),
        'updated_at': DateTime.now()
      }),
    ]);

    await _leconDao.storeMultiple(chapitres);
  }
}
