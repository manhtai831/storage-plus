import 'package:hive_storage/src/sqlite/interface/i_next.dart';
import 'package:hive_storage/src/sqlite/sqlite_curd_impl.dart';

abstract class ISqlOrder implements INext{
  ISqlOrder orderBy(OrderBy orderBy);
}
