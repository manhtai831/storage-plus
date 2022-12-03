import 'package:hive_storage/src/sqlite/interface/i_next.dart';

abstract class ISqlWhere implements INext {
  ISqlWhere where(String raw);

  ISqlWhere limit(int limit);

  ISqlWhere offset(int offset);
  
  ISqlWhere whereOne();

  ISqlWhere and();

  ISqlWhere or();
}
