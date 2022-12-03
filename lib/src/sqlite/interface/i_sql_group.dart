import 'package:hive_storage/src/sqlite/interface/i_next.dart';

abstract class ISqlGroup implements INext {
  ISqlGroup groupBy(String columnName);
  
  ISqlGroup having(String condition);
}
