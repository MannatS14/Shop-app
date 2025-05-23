import 'package:admin/utility/extensions.dart';

import '../../../core/data/data_provider.dart';
import '../../../models/product.dart';
import 'add_product_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utility/constants.dart';
import 'package:collection/collection.dart';

class ProductListSection extends StatelessWidget {
  const ProductListSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "All Products",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            width: double.infinity,
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                return DataTable(
                  columnSpacing: defaultPadding,
                  columns: [
                    DataColumn(
                      label: Text("Product Name"),
                    ),
                    DataColumn(
                      label: Text("Category"),
                    ),
                    DataColumn(
                      label: Text("Sub Category"),
                    ),
                    DataColumn(
                      label: Text("Price"),
                    ),
                    DataColumn(
                      label: Text("Edit"),
                    ),
                    DataColumn(
                      label: Text("Delete"),
                    ),
                  ],
                  rows: List.generate(
                    dataProvider.products.length,
                    (index) => productDataRow(
                      dataProvider.products[index],
                      edit: () {
                        showAddProductForm(
                            context, dataProvider.products[index]);
                      },
                      delete: () {
                        context.dashBoardProvider
                            .deleteProduct(dataProvider.products[index]);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

DataRow productDataRow(Product productInfo,
    {Function? edit, Function? delete}) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            // Safely handle image URL
            productInfo.images != null && productInfo.images!.isNotEmpty
                ? Image.network(
                    productInfo.images!
                            .firstWhereOrNull(
                                (image) => image.url?.isNotEmpty ?? false)
                            ?.url ??
                        '', // Fallback to empty string if no URL found
                    height: 30,
                    width: 30,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Icon(Icons.error);
                    },
                  )
                : Icon(Icons.image_not_supported), // Fallback icon if no images
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(productInfo.name ?? 'Unnamed Product'),
            ),
          ],
        ),
      ),
      DataCell(Text(productInfo.proCategoryId?.name ?? 'Unknown Category')),
      DataCell(
          Text(productInfo.proSubCategoryId?.name ?? 'Unknown SubCategory')),
      DataCell(
        Text('${productInfo.price ?? '0'}'), // Handle null price
      ),
      DataCell(IconButton(
          onPressed: () {
            if (edit != null) edit();
          },
          icon: Icon(
            Icons.edit,
            color: Colors.white,
          ))),
      DataCell(IconButton(
          onPressed: () {
            if (delete != null) delete();
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ))),
    ],
  );
}
