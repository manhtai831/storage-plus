import 'package:hive_storage/src/sqlite/interface/i_next.dart';

abstract class ISqlJoin implements INext {
  ISqlJoin innerJoin(String tableName);

  ISqlJoin join(String tableName);

  ISqlJoin on(String raw);
}
