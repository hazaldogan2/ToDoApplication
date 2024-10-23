import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DetailsController extends GetxController {
  var isDateEnabled = false.obs;
  var isTimeEnabled = false.obs;
  var selectedDate = DateTime.now().obs;
  var selectedTime = TimeOfDay.now().obs;
  var priority = 0.obs;
  var attachedFile = ''.obs;

  void toggleDate(bool value) {
    isDateEnabled(value);
    if (!value) selectedDate(DateTime.now());
  }

  void toggleTime(bool value) {
    isTimeEnabled(value);
    if (!value) selectedTime(TimeOfDay.now());
  }

  Future<void> pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) selectedDate(pickedDate);
  }

  Future<void> pickTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime.value,
    );
    if (pickedTime != null) selectedTime(pickedTime);
  }

  void setPriority(int value) {
    priority(value);
  }

  Future<void> pickFile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      attachedFile(pickedFile.path);
    }
  }
}
class DetailsTodoScreen extends StatelessWidget {
  final Function(DateTime, int, File?) onDetailsSelected;
  final DetailsController controller = Get.put(DetailsController());

  DetailsTodoScreen({required this.onDetailsSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.blue, fontSize: 18),
                ),
              ),
              const Text(
                'Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              TextButton(
                onPressed: () {
                  final DateTime dueDate = DateTime(
                    controller.selectedDate.value.year,
                    controller.selectedDate.value.month,
                    controller.selectedDate.value.day,
                    controller.selectedTime.value.hour,
                    controller.selectedTime.value.minute,
                  );

                  // File is selected, sends the File object
                  File? file = controller.attachedFile.value.isNotEmpty
                      ? File(controller.attachedFile.value)
                      : null;

                  onDetailsSelected(
                    dueDate,
                    controller.priority.value,
                    file,
                  );
                  Get.back();
                },
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.red),
                  SizedBox(width: 8),
                  Text("Date", style: TextStyle(fontSize: 20)),
                ],
              ),
              Obx(() => Switch(
                activeColor: Colors.white,
                activeTrackColor: Colors.green,
                inactiveTrackColor: Colors.grey.shade300,
                inactiveThumbColor: Colors.white,
                value: controller.isDateEnabled.value,
                onChanged: (val) => controller.toggleDate(val),
              )),
            ],
          ),
          Obx(() {
            if (controller.isDateEnabled.value) {
              return InkWell(
                onTap: () => controller.pickDate(context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(DateFormat.yMMMMd().format(controller.selectedDate.value)),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          const SizedBox(height: 15),
          // Time picker
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.access_time, color: Colors.blue),
                  SizedBox(width: 8),
                  Text("Time", style: TextStyle(fontSize: 20)),
                ],
              ),
              Obx(() => Switch(
                activeColor: Colors.white,
                activeTrackColor: Colors.green,
                inactiveTrackColor: Colors.grey.shade300,
                inactiveThumbColor: Colors.white,
                value: controller.isTimeEnabled.value,
                onChanged: (val) => controller.toggleTime(val),
              )),
            ],
          ),
          Obx(() {
            if (controller.isTimeEnabled.value) {
              return InkWell(
                onTap: () => controller.pickTime(context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(controller.selectedTime.value.format(context)),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          const SizedBox(height: 20),
          Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100,
            ),
            child: InkWell(
              onTap: () {
                Get.bottomSheet(
                  Container(
                    color: Colors.white,
                    height: 300,
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('None'),
                          onTap: () {
                            controller.setPriority(0);
                            Get.back();
                          },
                        ),
                        ListTile(
                          title: const Text('Low'),
                          onTap: () {
                            controller.setPriority(1);
                            Get.back();
                          },
                        ),
                        ListTile(
                          title: const Text('Medium'),
                          onTap: () {
                            controller.setPriority(2);
                            Get.back();
                          },
                        ),
                        ListTile(
                          title: const Text('High'),
                          onTap: () {
                            controller.setPriority(3);
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Priority",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 190),
                    Obx(() {
                      String priorityText;
                      switch (controller.priority.value) {
                        case 1:
                          priorityText = "Low";
                          break;
                        case 2:
                          priorityText = "Medium";
                          break;
                        case 3:
                          priorityText = "High";
                          break;
                        default:
                          priorityText = "None";
                      }
                      return Text(
                        priorityText,
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      );
                    }),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100,
            ),
            child: ListTile(
              title: const Text("Attach a file", style: TextStyle(fontSize: 20)),
              trailing: Obx(() => Text(controller.attachedFile.value.isNotEmpty
                  ? "File attached"
                  : "None", style: TextStyle(fontSize: 20, color: Colors.grey))),
              onTap: () async {
                await controller.pickFile(); //If the file is attached, it works a little slow after pressing the Add button, but it does the adding process.
              },
            ),
          ),
        ],
      ),
    );
  }
}















