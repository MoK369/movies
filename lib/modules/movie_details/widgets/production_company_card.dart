import 'package:flutter/material.dart';
import 'package:movies/core/image_url/image_url.dart';
import 'package:movies/core/models/movie_details/movie_details_model.dart';
import 'package:movies/core/widgets/cust_cached_network_image.dart';

class ProductionCompanyCard extends StatelessWidget {
  final ProductionCompany productionCompany;

  const ProductionCompanyCard({super.key, required this.productionCompany});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: Color(0xFF514F4F))),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: CustCachedNetworkImage(
            fit: BoxFit.contain,
            width: size.width * 0.35,
            imageUrl: ImageUrl.getFullUrl(productionCompany.logoPath ?? "")),
      ),
    );
  }
}
