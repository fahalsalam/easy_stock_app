import 'package:easy_stock_app/controllers/providers/masters_provider/user_configure_provider/user_configure_provider.dart';
import 'package:easy_stock_app/models/masters/user_master/user_model.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/view/masters/user_configure/user_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserListWidget extends StatefulWidget {
  List<User> data;
  UserListWidget({super.key, required this.data});

  @override
  State<UserListWidget> createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<User> _filteredUsers = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _filteredUsers = widget.data;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserConfigureProvider>(context, listen: false).fetchData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredUsers = widget.data;
        _isSearching = false;
      } else {
        _filteredUsers = widget.data
            .where((user) =>
                user.userName.toLowerCase().contains(query.toLowerCase()) ||
                user.userId
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
        _isSearching = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userManagementProvider = Provider.of<UserConfigureProvider>(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenHeight * 0.015),
        // Modern Header with Search
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Manage Users",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              // Modern Search Bar
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            onPressed: () {
                              _searchController.clear();
                              _filterUsers('');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: _filterUsers,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        // User List Container
        Center(
          child: Container(
            width: screenWidth * 0.9,
            height: screenHeight * 0.7,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
              child: _filteredUsers.isEmpty
                  ? Center(
                      child: Text(
                        _isSearching
                            ? "No matching users found"
                            : "No users to show",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.051),
                      shrinkWrap: true,
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        User user = _filteredUsers[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6.0,
                            horizontal: 5,
                          ),
                          child: Container(
                            height: screenHeight * 0.08,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // User Avatar
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: primaryColor.withOpacity(0.5),
                                      ),
                                    ),
                                    child: Text(
                                      user.userName.isNotEmpty
                                          ? user.userName[0].toUpperCase()
                                          : 'U',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                // User ID
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    user.userId.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                // User Name
                                Expanded(
                                  child: Text(
                                    user.userName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // Edit Button
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UserMasterEditPage(
                                            data: user,
                                            category: userManagementProvider
                                                .userCategory,
                                          ),
                                        ),
                                      ).then((_) {
                                        setState(() {
                                          _filteredUsers = widget.data;
                                          Provider.of<UserConfigureProvider>(
                                            context,
                                            listen: false,
                                          ).fetchData().then((_) {
                                            setState(() {
                                              _filteredUsers = Provider.of<
                                                  UserConfigureProvider>(
                                                context,
                                                listen: false,
                                              ).userData;
                                            });
                                          });
                                        });
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.1),
      ],
    );
  }
}
