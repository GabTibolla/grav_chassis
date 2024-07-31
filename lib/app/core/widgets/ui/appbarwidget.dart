import 'package:flutter/material.dart';

class AppbarWidget extends StatefulWidget implements PreferredSizeWidget {
  const AppbarWidget({
    super.key,
    this.centerTitle,
    this.automaticallyImplyLeading = true,
    required this.title,
    required this.backgroundColor,
    required this.onChanged,
    required this.onSearch,
  });

  final String title;
  final bool? centerTitle;
  final bool automaticallyImplyLeading;
  final Color backgroundColor;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSearch;

  @override
  AppbarWidgetState createState() => AppbarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AppbarWidgetState extends State<AppbarWidget> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _isSearching
          ? _buildSearchField()
          : Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
      actions: _buildActions(),
      centerTitle: widget.centerTitle,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      titleSpacing: 50,
      backgroundColor: widget.backgroundColor,
    );
  }

  Widget _buildSearchField() {
    return TextFormField(
      autofocus: true,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        hintText: "Pesquisar...",
        hintStyle: TextStyle(color: Colors.white),
      ),
      onChanged: widget.onChanged,
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search, color: Colors.white),
        onPressed: () {
          setState(() {
            if (_isSearching) {
              // Clear search text when exiting search mode
              widget.onSearch('');
            }
            _isSearching = !_isSearching;
          });
        },
      ),
    ];
  }
}
