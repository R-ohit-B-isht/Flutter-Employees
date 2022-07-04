import 'package:mongo_dart/mongo_dart.dart';
import 'package:sevr/sevr.dart';

void start() async {
  // Log into database
  final db = await Db.create(
      'mongodb+srv://rohitbisht:rohitbisht@cluster0.ztdzp.mongodb.net/test?retryWrites=true&w=majority');
  await db.open();
  final coll = db.collection('employees');

  // Create server
  const port = 8081;
  final serv = Sevr();

  // final corsPaths = ['/', '/:id'];
  // for (var route in corsPaths) {
  //   serv.options(route, [
  //     (req, res) {
  //       setCors(req, res);
  //       return res.status(200);
  //     }
  //   ]);
  // }

  serv.get('/', [
    (ServRequest req, ServResponse res) async {
      final employees = await coll.find().toList();
      return res.status(200).json({'employees': employees});
    }
  ]);

  serv.post('/', [
    (ServRequest req, ServResponse res) async {
      await coll.save(req.body);
      return res.json(
        await coll.findOne(where.eq('name', req.body['name'])),
      );
    }
  ]);

  serv.delete('/:id', [
    (ServRequest req, ServResponse res) async {
      await coll
          .remove(where.eq('_id', ObjectId.fromHexString(req.params['id'])));
      return res.status(200);
    }
  ]);

  // Listen for connections
  serv.listen(port, callback: () {
    print('Server listening on port: $port');
  });
}

// void setCors(ServRequest req, ServResponse res) {
//   res.response.headers.add('Access-Control-Allow-Origin', '*');
//   res.response.headers.add('Access-Control-Allow-Methods', 'GET, POST, DELETE');
//   res.response.headers
//       .add('Access-Control-Allow-Headers', 'Origin, Content-Type');
// }


//curl -X POST -H "Content-Type: application/json" -d '{"name":"Sam","experience":"2"}' http://localhost:8081