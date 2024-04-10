// import 'dart:async';

// import 'package:custom_timer/custom_timer.dart';
// import 'package:email_otp/email_otp.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:online_music_player/models/store_email.dart';
// import 'package:online_music_player/pages/loadingdialog.dart';
// import 'package:online_music_player/pages/passwordset.dart';
// import 'package:otp_timer_button/otp_timer_button.dart';

// import 'package:pinput/pinput.dart';

// class OtpScreen extends StatefulWidget {
//   Email email;
//   OtpScreen(this.email);

//   @override
//   State<OtpScreen> createState() => _OtpScreenState(email);
// }

// class _OtpScreenState extends State<OtpScreen> with TickerProviderStateMixin {
//   Email email;
//   _OtpScreenState(this.email);
//   OtpTimerButtonController resendOTP = OtpTimerButtonController();
//   late CustomTimerController controller = CustomTimerController(
//     vsync: this,
//     begin: const Duration(minutes: 2),
//     end: const Duration(seconds: 0),
//     initialState: CustomTimerState.reset,
//   );

//   TextEditingController o = TextEditingController();

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     controller.pause();
//     controller.reset();
//     controller.dispose();
//     super.dispose();
//   }

//   requestOtp() async {
//     resendOTP.loading();
//     await sendOtp();
//     resendOTP.startTimer();
//   }

//   EmailOTP otp = EmailOTP();
//   String verificationCode = '';
//   Future sendOtp() async {
//     otp.setConfig(
//       appEmail: 'onlinemusicplayer@gmail.com',
//       userEmail: email.email,
//       appName: 'Online Music Player',
//       otpLength: 6,
//       otpType: OTPType.digitsOnly,
//     );

//     if (await otp.sendOTP() == true) {
//       // Navigator.of(context).pop();
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text("OTP has been sent"),
//       ));
//       controller.start();
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text("Oops, OTP send failed"),
//       ));
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState

//     super.initState();
//     sendOtp().whenComplete(() => null);
//   }

//   void otpVerify(String x) async {
//     try {
//       if (await otp.verifyOTP(otp: x)) {
//         // ignore: use_build_context_synchronously
//         showDialog(
//             context: context,
//             builder: (context) {
//               return const LoadingDialog();
//             });
//         Timer(const Duration(seconds: 1), () {
//           Navigator.of(context).pop();
//           Navigator.of(context).pushReplacement(
//               MaterialPageRoute(builder: (context) => PasswordSet(email)));
//         });
//       } else {
//         Fluttertoast.showToast(msg: 'Invalid OTP');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final defaultPinTheme = PinTheme(
//       width: 56,
//       height: 56,
//       textStyle: const TextStyle(
//           fontSize: 20,
//           color: Color.fromRGBO(30, 60, 87, 1),
//           fontWeight: FontWeight.w600),
//       decoration: BoxDecoration(
//         border: Border.all(color: const Color.fromARGB(255, 3, 203, 203)),
//         borderRadius: BorderRadius.circular(20),
//       ),
//     );

//     final focusedPinTheme = defaultPinTheme.copyDecorationWith(
//       border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
//       borderRadius: BorderRadius.circular(8),
//     );

//     final submittedPinTheme = defaultPinTheme.copyWith(
//       decoration: defaultPinTheme.decoration?.copyWith(
//         color: const Color.fromRGBO(234, 239, 243, 1),
//       ),
//     );

//     return Material(
//       child: Material(
//         child: Scaffold(
//           extendBodyBehindAppBar: true,
//           appBar: AppBar(
//             backgroundColor: Colors.transparent,
//             elevation: 0.0,
//             // actions: [
//             // Container(
//             //     padding: const EdgeInsets.only(right: 15),
//             //     alignment: Alignment.center,
//             //     child: CustomTimer(
//             //         controller: controller,
//             //         builder: (state, time) {
//             //           return Text(
//             //             '${time.minutes}:${time.seconds}s',
//             //             style: const TextStyle(
//             //                 fontSize: 18.0, color: Colors.black),
//             //           );
//             //         })),
//             // ],
//           ),
//           body: GestureDetector(
//             onTap: () {
//               FocusScope.of(context).unfocus();
//             },
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               margin: const EdgeInsets.all(30),
//               alignment: Alignment.center,
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Image.asset(
//                       'assets/images/otp.png',
//                       width: 150,
//                       height: 150,
//                     ),
//                     const SizedBox(
//                       height: 25,
//                     ),
//                     const Text(
//                       "OTP Verification",
//                       style:
//                           TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     const Text(
//                       'Check your registered Email Id to Enter OTP',
//                       style: TextStyle(
//                         fontSize: 16,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     Pinput(
//                       length: 6,
//                       defaultPinTheme: defaultPinTheme,
//                       focusedPinTheme: focusedPinTheme,
//                       submittedPinTheme: submittedPinTheme,
//                       showCursor: true,
//                       controller: o,
//                       onChanged: (value) {
//                         verificationCode = value;
//                       },
//                       onSubmitted: (v) {
//                         verificationCode = v;
//                         otpVerify(verificationCode);
//                       },
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       height: 50,
//                       child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(35))),
//                           onPressed: () {
//                             otpVerify(verificationCode);
//                           },
//                           child: const Text("VERIFY")),
//                     ),
//                     // Container(
//                     //   margin: const EdgeInsets.only(top: 20),
//                     //   child: Row(
//                     //     mainAxisAlignment: MainAxisAlignment.center,
//                     //     children: [
//                     //       const Padding(
//                     //         padding: EdgeInsets.only(top: 0),
//                     //       ),
//                     //       OtpTimerButton(
//                     //         controller: resendOTP,
//                     //         onPressed: () {
//                     //           requestOtp();
//                     //           controller.reset();
//                     //         },
//                     //         text: const Text(
//                     //           'RESEND OTP',
//                     //           style: TextStyle(color: Colors.white),
//                     //         ),
//                     //         duration: 15,
//                     //         backgroundColor: Colors.lightGreen,
//                     //       )
//                     //     ],
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
