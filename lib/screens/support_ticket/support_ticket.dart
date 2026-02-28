import 'dart:io';
import 'package:active_matrimonial_flutter_app/components/common_app_bar.dart';
import 'package:active_matrimonial_flutter_app/components/common_input.dart';
import 'package:active_matrimonial_flutter_app/components/common_widget.dart';
import 'package:active_matrimonial_flutter_app/components/my_images.dart';
import 'package:active_matrimonial_flutter_app/components/name_date_row.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/support_ticket/support_ticket_create_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/support_ticket/support_ticket_create_reducer.dart';
import 'package:active_matrimonial_flutter_app/screens/support_ticket/support_ticket_middleware.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_summernote/flutter_summernote.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:one_context/one_context.dart';

class SupportTicket extends StatefulWidget {
  const SupportTicket({super.key});
  @override
  State<SupportTicket> createState() => _SupportTicketState();
}

class _SupportTicketState extends State<SupportTicket> {
  final _replySummernoteKey = GlobalKey<FlutterSummernoteState>();

  Future getReplyImage() async {
    try {
      final image = await store.state.supportTicketReplyState!.replyImagePicker!
          .pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporay = File(image.path);

      store.dispatch(
        StoreReplyImageAction(
          image: imageTemporay,
          image_name: imageTemporay.path.split('/').last,
        ),
      );
    } on PlatformException catch (e) {
      print("Failed to pick Image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit:
          (store) => [
            store.dispatch(getSupportTicketMiddleware()),
            store.dispatch(getSupportTicketCategoriesMiddleware()),
          ],
      builder:
          (_, state) => Scaffold(
            appBar: CommonAppBar(
              text: AppLocalizations.of(context)!.support_ticket,
            ).build(context),
            body: Column(
              children: [
                buildCreateTicket(state, context),
                Const.height20,
                state.supportTicketState!.isFetching == false
                    ? buildListViewSeparated(state)
                    : Expanded(child: CommonWidget.circularIndicator),
              ],
            ),
          ),
    );
  }

  Widget buildListViewSeparated(AppState state) {
    return Expanded(
      child:
          state.supportTicketState!.myTickets!.isEmpty
              ? Text('Nodata')
              : ListView.separated(
                itemCount: state.supportTicketState!.myTickets!.length,
                separatorBuilder:
                    (BuildContext context, int index) => Const.height15,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    /// box decoration
                    margin: EdgeInsets.symmetric(
                      horizontal: Const.kPaddingHorizontal,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                      boxShadow: [CommonWidget.box_shadow()],
                    ),

                    // child0
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        top: 14,
                        bottom: 14,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state
                                .supportTicketState!
                                .myTickets![index]
                                .ticketId,
                            style: Styles.bold_arsenic_14,
                          ),
                          const SizedBox(height: 9),
                          NameDataRow(
                            name:
                                AppLocalizations.of(
                                  context,
                                )!.support_ticket_status,
                            data:
                                state
                                            .supportTicketState!
                                            .myTickets![index]
                                            .status ==
                                        0
                                    ? "Pending"
                                    : "Approved",
                            style: TextStyle(
                              color:
                                  state
                                              .supportTicketState!
                                              .myTickets![index]
                                              .status ==
                                          1
                                      ? MyTheme.green
                                      : MyTheme.app_accent_color,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Const.height5,
                          NameDataRow(
                            name:
                                AppLocalizations.of(
                                  context,
                                )!.support_ticket_subject,
                            data:
                                state
                                    .supportTicketState!
                                    .myTickets![index]
                                    .subject,
                          ),
                          Const.height5,
                          NameDataRow(
                            name:
                                AppLocalizations.of(
                                  context,
                                )!.support_ticket_category,
                            data:
                                state
                                    .supportTicketState!
                                    .myTickets![index]
                                    .supportCategoryName,
                          ),
                          Const.height5,
                          NameDataRow(
                            name:
                                AppLocalizations.of(
                                  context,
                                )!.support_ticket_new_reply,
                            data: DateFormat('yyyy-MM-dd').format(
                              state
                                  .supportTicketState!
                                  .myTickets![index]
                                  .createdAt,
                            ),
                          ),
                          Const.height20,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /// view ticket
                              buildViewOfTicket(
                                state.supportTicketState!.myTickets![index],
                                state,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }

  Widget buildViewOfTicket(detail, AppState state) {
    return InkWell(
      onTap: () {
        _replySummernoteKey.currentState?.setText('');
        store.dispatch(ResetReplyStateAction());
        OneContext().showDialog(
          builder: (context) {
            return Dialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(
                                context,
                              )!.support_ticket_details,
                              style: Styles.bold_arsenic_14,
                            ),
                            IconButton(
                              onPressed: () {
                                store.dispatch(ResetReplyStateAction());
                                Navigator.pop(context, true);
                              },
                              icon: Image.asset(
                                'assets/icon/icon_cross.png',
                                height: 20,
                                width: 15,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: MyTheme.light_grey),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                detail.subject,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const Divider(),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: MyTheme.zircon),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: FlutterSummernote(
                                  key: _replySummernoteKey,
                                  height: 250,
                                  hint: 'Type your reply here...',
                                  customToolbar: """
                                [
                                  ['style', ['bold', 'italic', 'underline', 'clear']],
                                  ['para', ['ul', 'ol', 'paragraph']]
                                ]
                                """,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: getReplyImage,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: Styles.buildLinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Icon(Icons.attachment),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      final String? replyText =
                                          await _replySummernoteKey.currentState
                                              ?.getText();
                                      if (replyText != null &&
                                          replyText.isNotEmpty) {
                                        store.dispatch(
                                          storeSupportTicketReplyMiddleware(
                                            ticket_id: detail.id,
                                            reply: replyText,
                                            attachment:
                                                state
                                                    .supportTicketReplyState!
                                                    .image,
                                          ),
                                        );
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        _replySummernoteKey.currentState
                                            ?.setText('');
                                        store.dispatch(ResetReplyStateAction());
                                        Navigator.pop(context, true);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: Styles.buildLinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Icon(Icons.send),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              StoreConnector<AppState, AppState>(
                                converter: (store) => store.state,
                                builder: (_, state3) {
                                  final imageName =
                                      state3.supportTicketReplyState!.img_name;
                                  final hasImage =
                                      imageName != null && imageName.isNotEmpty;

                                  return Text(
                                    hasImage ? imageName : "Choose file",
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              Column(
                                children: [
                                  for (final reply in detail.reply)
                                    Builder(
                                      builder: (context) {
                                        final myPhotoUrl =
                                            state
                                                .accountState
                                                ?.profileData
                                                ?.memberPhoto;
                                        final bool isMyReply =
                                            myPhotoUrl != null &&
                                            reply.repliedUserImage ==
                                                myPhotoUrl;

                                        final avatar = ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            25.0,
                                          ),
                                          child: SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: MyImages.normalImage(
                                              reply.repliedUserImage ?? '',
                                            ),
                                          ),
                                        );
                                        final messageBubble = Flexible(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  isMyReply
                                                      ? MyTheme.app_accent_color
                                                      : MyTheme.zircon
                                                          .withOpacity(0.8),
                                              borderRadius: BorderRadius.only(
                                                topLeft: const Radius.circular(
                                                  16,
                                                ),
                                                topRight: const Radius.circular(
                                                  16,
                                                ),
                                                bottomLeft:
                                                    isMyReply
                                                        ? const Radius.circular(
                                                          16,
                                                        )
                                                        : Radius.zero,
                                                bottomRight:
                                                    isMyReply
                                                        ? Radius.zero
                                                        : const Radius.circular(
                                                          16,
                                                        ),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Html(
                                                  data: reply.reply ?? '',
                                                  style: {
                                                    "body": Style(
                                                      color:
                                                          isMyReply
                                                              ? Colors.white
                                                              : Colors.black,
                                                    ),
                                                  },
                                                ),
                                                if (reply.replyAttachment !=
                                                        null &&
                                                    reply
                                                        .replyAttachment!
                                                        .isNotEmpty)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 8.0,
                                                        ),
                                                    child: SizedBox(
                                                      width: 100,
                                                      height: 100,
                                                      child: MyImages.normalImage(
                                                        reply.replyAttachment!,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4.0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                isMyReply
                                                    ? MainAxisAlignment.end
                                                    : MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              if (!isMyReply) ...[
                                                avatar,
                                                const SizedBox(width: 8),
                                              ],
                                              messageBubble,
                                              if (isMyReply) ...[
                                                const SizedBox(width: 8),
                                                avatar,
                                              ],
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                              const Divider(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    foregroundImage:
                                        state
                                                    .accountState!
                                                    .profileData!
                                                    .memberPhoto ==
                                                null
                                            ? const AssetImage(
                                              'assets/images/default_avater.png',
                                            )
                                            : NetworkImage(
                                                  state
                                                      .accountState!
                                                      .profileData!
                                                      .memberPhoto!,
                                                )
                                                as ImageProvider,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Html(data: detail.description ?? ''),
                                        const SizedBox(height: 10),
                                        if (detail.attachments != null &&
                                            detail.attachments!.isNotEmpty)
                                          SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: MyImages.normalImage(
                                              detail.attachments!,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 7),
        decoration: BoxDecoration(
          gradient: Styles.buildLinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            AppLocalizations.of(context)!.support_ticket_view,
            style: Styles.bold_white_14,
          ),
        ),
      ),
    );
  }

  Widget buildCreateTicket(AppState state, BuildContext context) {
    return InkWell(
      onTap: () => buildCreateTicketShowDialog(state, context),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Const.kPaddingHorizontal,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          color: MyTheme.zircon,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: Center(
            child: Column(
              children: [
                IconButton(
                  icon: Image.asset('assets/icon/icon_plus.png', height: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: null,
                ),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.support_ticket_create_ticket,
                  style: Styles.regular_storm_grey_12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> buildCreateTicketShowDialog(
    AppState state,
    BuildContext context,
  ) {
    return OneContext().showDialog(
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.80,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Create Ticket", style: Styles.bold_arsenic_14),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          icon: Image.asset(
                            'assets/icon/icon_cross.png',
                            height: 15,
                            width: 10,
                            color: MyTheme.arsenic,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: MyTheme.light_grey),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: CreateTicketForm(state: state),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CreateTicketForm extends StatefulWidget {
  final AppState state;

  const CreateTicketForm({super.key, required this.state});

  @override
  State<CreateTicketForm> createState() => _CreateTicketFormState();
}

class _CreateTicketFormState extends State<CreateTicketForm> {
  final _formKey = GlobalKey<FormState>();
  final _summernoteKey = GlobalKey<FlutterSummernoteState>();
  late final TextEditingController _subjectController;
  dynamic _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
  }

  Future getImage() async {
    try {
      final image = await store.state.supportTicketCreateState!.picker
          .pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporay = File(image.path);

      store.dispatch(
        StoreImageAction(
          image: imageTemporay,
          image_name: imageTemporay.path.split('/').last,
        ),
      );
    } on PlatformException catch (e) {
      print("Failed to pick Image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// subject
          RichText(
            text: TextSpan(
              text: AppLocalizations.of(context)!.support_ticket_subject,
              style: Styles.bold_arsenic_16,
              children: [
                TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _subjectController,
            decoration: InputStyle.inputDecoration_text_field(
              hint: "Enter Ticket Subject",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a subject.';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          RichText(
            text: TextSpan(
              text: AppLocalizations.of(context)!.support_ticket_sub_category,
              style: Styles.bold_arsenic_16,
              children: [
                TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          const SizedBox(height: 8),

          SizedBox(
            height: 50,
            child: DropdownButtonFormField<dynamic>(
              value: _selectedCategoryId,
              hint: Text('Select One', style: Styles.regular_gull_grey_12),
              iconSize: 0.0,
              decoration: InputStyle.inputDecoration_text_field(
                suffixIcon: const Icon(Icons.keyboard_arrow_down),
              ),
              items:
                  widget.state.supportTicketState!.ticketCategories!
                      .map<DropdownMenuItem<dynamic>>((e) {
                        return DropdownMenuItem<dynamic>(
                          value: e.id,
                          child: Text(
                            e.name,
                            style: Styles.regular_gull_grey_12,
                          ),
                        );
                      })
                      .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Please select a category.';
                }
                return null;
              },
              onChanged: (dynamic newValue) {
                setState(() {
                  _selectedCategoryId = newValue;
                });
              },
            ),
          ),

          const SizedBox(height: 15),
          Text(
            AppLocalizations.of(context)!.support_ticket_details,
            style: Styles.bold_arsenic_12,
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: MyTheme.zircon),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: FlutterSummernote(
              key: _summernoteKey,
              height: 250,
              hint: 'Your text here...',
              customToolbar: """
              [
                ['style', ['bold', 'italic', 'underline', 'clear']],
                ['para', ['ul', 'ol', 'paragraph']],
                ['height', ['height']]
              ]
            """,
            ),
          ),
          const SizedBox(height: 15),
          StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder:
                (context, state2) => Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    TextFormField(
                      readOnly: true,
                      decoration: InputStyle.inputDecoration_text_field(
                        hint:
                            state2.supportTicketCreateState!.img_name != ''
                                ? state2.supportTicketCreateState!.img_name
                                : "Choose file",
                      ),
                    ),
                    Positioned(
                      right: 5,
                      child: SizedBox(
                        width: 100,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              MyTheme.white,
                            ),
                            shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          onPressed: () {
                            getImage();
                          },
                          child: const Text('Browse'),
                        ),
                      ),
                    ),
                  ],
                ),
          ),

          const SizedBox(height: 15),

          InkWell(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                final String? details =
                    await _summernoteKey.currentState?.getText();

                store.dispatch(
                  supportTicketCreateMiddleware(
                    subject: _subjectController.text,
                    category: _selectedCategoryId.toString(),
                    details: details ?? '',
                    image: store.state.supportTicketCreateState!.image,
                  ),
                );

                FocusManager.instance.primaryFocus?.unfocus();
                store.dispatch(ResetAction());

                Navigator.of(context).pop();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 7),
              decoration: BoxDecoration(
                gradient: Styles.buildLinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(6.0)),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  AppLocalizations.of(context)!.support_ticket_send,
                  style: Styles.bold_white_14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SupportTicketReplyState {
  ImagePicker? replyImagePicker = ImagePicker();
  File? image;
  String? img_name;

  SupportTicketReplyState({this.image, this.img_name, this.replyImagePicker});

  SupportTicketReplyState.initialState() : img_name = '';
}

class StoreReplyImageAction {
  File? image;
  String? image_name;

  StoreReplyImageAction({this.image, this.image_name});
}

class ResetReplyStateAction {}

SupportTicketReplyState? support_ticket_reply_reducer(
  SupportTicketReplyState? state,
  dynamic action,
) {
  if (action is StoreReplyImageAction) {
    state!.image = action.image;
    state.img_name = action.image_name;
    return state;
  }
  if (action is ResetReplyStateAction) {
    state!.image = null;
    state.img_name = '';
    return state;
  }
  return state;
}
