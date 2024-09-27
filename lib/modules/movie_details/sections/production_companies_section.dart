import 'package:flutter/material.dart';
import 'package:movies/core/bases/base_view.dart';
import 'package:movies/core/models/movie_details/movie_details_model.dart';
import 'package:movies/core/view_models/api_view_models/movie_details_view_model.dart';
import 'package:movies/modules/home/pages/home_page/widgets/custom_view_model_consumer.dart';
import 'package:movies/modules/movie_details/widgets/production_company_card.dart';

class ProductionCompaniesSection extends StatefulWidget {
  const ProductionCompaniesSection({super.key});

  @override
  State<ProductionCompaniesSection> createState() =>
      _ProductionCompaniesSectionState();
}

class _ProductionCompaniesSectionState
    extends BaseView<ProductionCompaniesSection> {
  bool showProductionCompaniesSection = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      color: const Color(0xFF282A28).withOpacity(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Production Companies:",
            style: theme.textTheme.labelMedium,
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: size.width,
            height: (size.width * 0.35),
            child: CustomViewModelConsumer<MovieDetailsViewModel,
                MovieDetailsModel>(
              shimmerWidth: size.width,
              shimmerHeight: size.height * 3,
              errorIconSize: 25,
              successFunction: (successState) {
                var productionCompanies =
                    successState.data.productionCompanies ?? [];
                if (productionCompanies.isEmpty) {
                  showProductionCompaniesSection = false;
                  WidgetsBinding.instance.addPostFrameCallback(
                    (timeStamp) {
                      setState(() {});
                    },
                  );
                }
                return ListView.builder(
                  cacheExtent: 300,
                  scrollDirection: Axis.horizontal,
                  itemCount: productionCompanies.length,
                  itemBuilder: (context, index) {
                    return ProductionCompanyCard(
                        productionCompany: productionCompanies[index]);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
