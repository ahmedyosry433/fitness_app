import 'package:fitness/features/food/data/datasources/food_remote_data_source_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FoodRemoteDataSourceContract)
class FoodRemoteDataSourceImpl
    implements FoodRemoteDataSourceContract {
  final FoodRemoteDataSourceImpl foodRemoteDataSourceImpl;
  FoodRemoteDataSourceImpl({required this.foodRemoteDataSourceImpl});
}
