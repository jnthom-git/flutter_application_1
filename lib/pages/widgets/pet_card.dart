// lib/widgets/pet_card.dart

import 'dart:io';
import 'package:flutter/material.dart';
import '../models/pet.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback onTap;

  const PetCard({
    Key? key,
    required this.pet,
    required this.onTap,
  }) : super(key: key);

  ImageProvider? _getImageProvider() {
    if (pet.imagePath == null) return null;
    
    // Check if it's an asset path or file path
    if (pet.imagePath!.startsWith('assets/')) {
      return AssetImage(pet.imagePath!);
    } else {
      return FileImage(File(pet.imagePath!));
    }
  }

  @override
  Widget build(BuildContext context) {
    print('PetCard: ${pet.name}, Image path: ${pet.imagePath}');
    
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: ClipOval(
              child: pet.imagePath != null && pet.imagePath!.isNotEmpty
                  ? (pet.imagePath!.startsWith('assets/')
                      ? Image.asset(
                          pet.imagePath!,
                          fit: BoxFit.cover,
                          width: 70,
                          height: 70,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading pet image: $error');
                            return Icon(
                              Icons.pets,
                              size: 35,
                              color: Colors.grey[600],
                            );
                          },
                        )
                      : Image.file(
                          File(pet.imagePath!),
                          fit: BoxFit.cover,
                          width: 70,
                          height: 70,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading pet image: $error');
                            return Icon(
                              Icons.pets,
                              size: 35,
                              color: Colors.grey[600],
                            );
                          },
                        ))
                  : Icon(
                      Icons.pets,
                      size: 35,
                      color: Colors.grey[600],
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            pet.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}