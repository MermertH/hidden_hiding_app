import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_hiding_app/controller/secret_vault_controller.dart';
import 'package:hidden_hiding_app/preferences.dart';

class FilterAreaWidget extends StatelessWidget {
  const FilterAreaWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SecretVaultController _vaultCont = Get.find();
    return Obx(
      () => Scrollbar(
        controller: _vaultCont.filterController,
        thumbVisibility: _vaultCont.getIsFilterMode.value,
        thickness: 3,
        child: SingleChildScrollView(
          controller: _vaultCont.filterController,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            child: _vaultCont.getIsFilterMode.value
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text("View Style:",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          )),
                                ),
                              ),
                              Flexible(
                                flex: 8,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            _vaultCont.getFileView.value
                                                ? Colors.black
                                                : Colors.grey.shade700,
                                      ),
                                      onPressed: () {
                                        Preferences().setViewStyle = true;
                                        _vaultCont.setFileView = true;
                                      },
                                      child: Text("File",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              )),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            !_vaultCont.getFileView.value
                                                ? Colors.black
                                                : Colors.grey.shade700,
                                      ),
                                      onPressed: () {
                                        Preferences().setViewStyle = false;
                                        _vaultCont.setFileView = false;
                                      },
                                      child: Text("List",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, bottom: 12),
                          child: Text("Extension Filter:",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  )),
                        ),
                        SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 4,
                                  color: Colors.grey[600],
                                ),
                                Flexible(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _vaultCont.extensionTypes.length,
                                    itemBuilder: (context, index) {
                                      return Align(
                                        widthFactor: 1.5,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: _vaultCont
                                                      .extensionTypes.values
                                                      .toList()[index]
                                                      .value
                                                  ? Colors.black
                                                  : Colors.grey.shade700,
                                            ),
                                            onPressed: () async => await _vaultCont
                                                .setActiveExtensionsAndUpdateItems(
                                                    index),
                                            child: Text(_vaultCont
                                                .extensionTypes.keys
                                                .toList()[index]),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  width: 4,
                                  color: Colors.grey[600],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text("List Sorting",
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  )),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            RadioListTile<String>(
                              title: const Text('From A to Z'),
                              value: "A_Z",
                              groupValue: _vaultCont.getCurrentSort.value,
                              onChanged: (String? value) async =>
                                  await _vaultCont
                                      .updateCurrentSortAndItems(value!),
                            ),
                            RadioListTile<String>(
                              title: const Text('From Z to A'),
                              value: "Z_A",
                              groupValue: _vaultCont.getCurrentSort.value,
                              onChanged: (String? value) async =>
                                  await _vaultCont
                                      .updateCurrentSortAndItems(value!),
                            ),
                            RadioListTile<String>(
                              title: const Text('From first date'),
                              value: "firstDate",
                              groupValue: _vaultCont.getCurrentSort.value,
                              onChanged: (String? value) async =>
                                  await _vaultCont
                                      .updateCurrentSortAndItems(value!),
                            ),
                            RadioListTile<String>(
                              title: const Text('From last date'),
                              value: "lastDate",
                              groupValue: _vaultCont.getCurrentSort.value,
                              onChanged: (String? value) async =>
                                  await _vaultCont
                                      .updateCurrentSortAndItems(value!),
                            ),
                            RadioListTile<String>(
                              title: const Text('From high to lower file size'),
                              value: "sizeDescending",
                              groupValue: _vaultCont.getCurrentSort.value,
                              onChanged: (String? value) async =>
                                  await _vaultCont
                                      .updateCurrentSortAndItems(value!),
                            ),
                            RadioListTile<String>(
                              title: const Text('From low to higher file size'),
                              value: "sizeAscending",
                              groupValue: _vaultCont.getCurrentSort.value,
                              onChanged: (String? value) async =>
                                  await _vaultCont
                                      .updateCurrentSortAndItems(value!),
                            ),
                          ],
                        ),
                        Container(
                          height: 4,
                          color: Colors.grey.shade800,
                        ),
                      ],
                    ),
                  )
                : const SizedBox(
                    width: double.maxFinite,
                  ),
          ),
        ),
      ),
    );
  }
}
