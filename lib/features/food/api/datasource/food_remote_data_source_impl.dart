import 'package:fitness/features/food/data/datasources/food_remote_data_source_contract.dart';
import 'package:injectable/injectable.dart';
import 'package:fitness/features/food/api/api_client/food_api_client.dart';
@Injectable(as: FoodRemoteDataSourceContract)
class FoodRemoteDataSourceImpl
    implements FoodRemoteDataSourceContract {
  final FoodApiClient foodApiClient;
  FoodRemoteDataSourceImpl({required this.foodApiClient});
}
