import 'package:hive_storage/src/sqlite/interface/i_next.dart';

abstract class ISqlWhere implements INext{
  ISqlWhere where(String raw);

  ISqlWhere and();

  ISqlWhere or();

  ISqlWhere limit(int limit);

  ISqlWhere offset(int offset);
}
