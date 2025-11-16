import 'dart:io';
import 'package:flutter/material.dart';

class FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final String? userProfileImage;
  final Function(int) onTap;

  const FloatingNavBar({
    Key? key,
    required this.currentIndex,
    this.userProfileImage,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.home_rounded,
            label: 'Home',
            index: 0,
          ),
          _buildNavItem(
            icon: Icons.calendar_today_rounded,
            label: 'Schedule',
            index: 1,
          ),
          _buildNavItem(
            icon: Icons.favorite_rounded,
            label: 'Health',
            index: 2,
          ),
          _buildProfileNavItem(
            index: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = currentIndex == index;
    
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF6B6B) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey[600],
          size: 24,
        ),
      ),
    );
  }

  Widget _buildProfileNavItem({required int index}) {
    final isSelected = currentIndex == index;
    
    print('FloatingNavBar - userProfileImage: $userProfileImage');
    
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF6B6B) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? Colors.white : Colors.grey[300],
          ),
          child: ClipOval(
            child: userProfileImage != null && userProfileImage!.isNotEmpty
                ? Image.file(
                    File(userProfileImage!),
                    fit: BoxFit.cover,
                    width: 32,
                    height: 32,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading nav bar profile image: $error');
                      return Icon(
                        Icons.person_rounded,
                        color: isSelected ? const Color(0xFFFF6B6B) : Colors.grey[600],
                        size: 20,
                      );
                    },
                  )
                : Icon(
                    Icons.person_rounded,
                    color: isSelected ? const Color(0xFFFF6B6B) : Colors.grey[600],
                    size: 20,
                  ),
          ),
        ),
      ),
    );
  }
}