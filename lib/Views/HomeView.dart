import 'package:flutter/material.dart';
import 'package:notesassignment/AppConstants/Apptoasts.dart';
import 'package:notesassignment/AppConstants/TxtStyles.dart';
import 'package:notesassignment/Controllers.dart/InternetController.dart';
import 'package:notesassignment/Controllers.dart/NoteController.dart';
import 'package:provider/provider.dart';

class Homeview extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer2<Notecontroller, InternetController>(
      builder: (context, noteCtrl, intCtrl, child) {
        return Scaffold(
          backgroundColor: scaffoldBg,

          appBar: AppBar(
            elevation: 0,
            title: Text(
              "My Notes",
              style: TxtStyles.customStyle(
                color: whiteColor,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [gradient1, gradient2]),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.sync, color: whiteColor),
                onPressed: () {
                  if (intCtrl.isOnline) {
                    noteCtrl.sync();
                  } else {
                    AppToastMessages.warningMessage(
                      msg: "You are currently offline",
                    );
                  }
                },
              ),
            ],
          ),

          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        maxLines: 3,
                        minLines: 1,
                        style: TxtStyles.customStyle(
                          fontSize: 15.0,
                          color: inputColor,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: "Write a note...",
                          hintStyle: TxtStyles.customStyle(
                            color: greyColor2,
                            fontWeight: FontWeight.w400,
                          ),

                          prefixIcon: Icon(
                            Icons.sticky_note_2_outlined,
                            color: gradient2.withOpacity(0.7),
                          ),

                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(width: 6),

                    InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        if (controller.text.trim().isEmpty) return;

                        noteCtrl.addNote(controller.text);
                        controller.clear();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [gradient1, gradient2],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: gradient2.withOpacity(0.3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.send_rounded,
                          color: whiteColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: noteCtrl.notes.isEmpty
                    ? Center(
                        child: Text(
                          "No Notes Yet ✍️",
                          style: TxtStyles.customStyle(color: greyColor),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: noteCtrl.notes.length,
                        itemBuilder: (_, i) {
                          final note = noteCtrl.notes[i];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: note.isLiked
                                  ? Colors.red.withOpacity(0.05)
                                  : whiteColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: note.isSynced
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.orange.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      note.isSynced
                                          ? Icons.cloud_done
                                          : Icons.cloud_upload,
                                      color: note.isSynced
                                          ? Colors.green
                                          : Colors.orange,
                                    ),

                                    const SizedBox(width: 8),

                                    Text(
                                      note.isSynced ? "Synced" : "Pending",
                                      style: TxtStyles.customStyle(
                                        color: note.isSynced
                                            ? Colors.green
                                            : Colors.orange,
                                        fontSize: 12.0,
                                      ),
                                    ),

                                    const Spacer(),

                                    IconButton(
                                      icon: Icon(
                                        note.isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: note.isLiked
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      onPressed: () {
                                        noteCtrl.toggleLike(note.id);
                                      },
                                    ),

                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        _showEditDialog(
                                          context,
                                          noteCtrl,
                                          note.id,
                                          note.content,
                                        );
                                      },
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  note.content,
                                  style: TxtStyles.customStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),

          floatingActionButton: FloatingActionButton(
            backgroundColor: gradient2,
            onPressed: () {
              if (intCtrl.isOnline) {
                noteCtrl.sync();
              } else {
                AppToastMessages.warningMessage(
                  msg: "You are currently offline",
                );
              }
            },
            child: const Icon(Icons.sync, color: whiteColor),
          ),
        );
      },
    );
  }

  void _showEditDialog(
    BuildContext context,
    Notecontroller controller,
    String id,
    String oldText,
  ) {
    final editController = TextEditingController(text: oldText);

    showDialog(
      context: context,

      builder: (_) {
        return AlertDialog(
          backgroundColor: whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: Text(
            "Edit Note",
            style: TxtStyles.customStyle(fontSize: 18.0, color: inputColor),
          ),
          content: TextField(
            controller: editController,
            style: TxtStyles.customStyle(fontSize: 12.0, color: inputColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.editNote(id, editController.text);
                Navigator.pop(context);
              },
              child: Text(
                "Save",
                style: TxtStyles.customStyle(fontSize: 14.0, color: inputColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
