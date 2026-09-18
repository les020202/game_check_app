// import 'package:flutter/material.dart';

// class CharacterButton extends StatefulWidget {
//   const CharacterButton({super.key});

//   @override
//   State<CharacterButton> createState() => _CharacterButtonState();
// }

// class _CharacterButtonState extends State<CharacterButton> {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: [
//             if (newCharacterName.length != 0)
//               ...List.generate(newCharacterName.length, (index) {
//                 final itemId = newCharacterIds[index];
//                 return Padding(
//                   key: ValueKey(itemId),
//                   padding: EdgeInsets.only(right: 5),
//                   child: InputChip(
//                     label: IntrinsicWidth(
//                       child: TextField(
//                         controller:
//                             TextEditingController(text: newCharacterName[index])
//                               ..selection = TextSelection.collapsed(
//                                 offset: newCharacterName[index].length,
//                               ),
//                         onChanged: (String name) {
//                           newCharacterName[index] = name;
//                         },
//                         onTap: () {
//                           setState(() {
//                             chracterSelectedIndex = index;
//                           });
//                         },
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: chracterSelectedIndex == index ? Colors.white : Colors.black,
//                         ),
//                         textAlign: TextAlign.center,
//                         decoration: const InputDecoration(
//                           isDense: true, 
//                           contentPadding: EdgeInsets.zero, 
//                           border: InputBorder.none, 
//                           isCollapsed: true, 
//                         ),
//                       ),
//                     ),
//                     selected: isSelected = chracterSelectedIndex == index,
//                     onSelected: (bool selected) {
//                       setState(() {
//                         chracterSelectedIndex = index;
//                       });
//                     },
//                     showCheckmark: false,
//                     labelPadding: EdgeInsets.symmetric(horizontal: 8),
//                     selectedColor: Colors.blue,
//                     backgroundColor: Colors.white,
//                     labelStyle: TextStyle(
//                       color: isSelected ? Colors.white : Colors.black,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     deleteIcon: const Icon(Icons.close, size: 18),
//                     onDeleted: () {
//                       setState(() {
//                         if (chracterSelectedIndex == index) {
//                           chracterSelectedIndex = -1;
//                         } else if (chracterSelectedIndex != null &&
//                             chracterSelectedIndex! > index) {
//                           chracterSelectedIndex = chracterSelectedIndex! - 1;
//                         }
//                         newCharacterIds.removeAt(index);
//                         newCharacterName.removeAt(index);
//                       });
//                     },
//                   ),
//                 );
//               }),
//             Padding(
//               padding: const EdgeInsets.all(5.0),
//               child: DottedBorder(
//                 options: CircularDottedBorderOptions(
//                   dashPattern: [6, 3],
//                   strokeWidth: 1.5,
//                   color: Colors.blue,
//                   padding: EdgeInsets.zero,
//                 ),
//                 child: SizedBox(
//                   width: 36,
//                   height: 36,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         newCharacterIds.add(uuid.v4());
//                         newCharacterName.add('');
//                       });
//                     },
//                     style: ElevatedButton.styleFrom(
//                       elevation: 0,
//                       backgroundColor: Colors.white,
//                       shape: CircleBorder(),
//                       padding: EdgeInsets.zero,
//                       side: BorderSide.none,
//                     ),
//                     child: Text(
//                       '+',
//                       style: TextStyle(fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//   }
// }