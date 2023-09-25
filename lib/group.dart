import 'package:chat_grouping/main.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Group> groups = [
    Group('Group 1', 'Description for Group 1', []),
    Group('Group 2', 'Description for Group 2', []),
    // Add more initial groups here
  ];

  final List<User> dummyUsers = [
    User('John Doe'),
    User('Jane Smith'),
    User('Bob Johnson'),
    // Add more dummy users here
  ];

  void _deleteGroup(Group group) {
    // Implement group deletion logic here
    setState(() {
      groups.remove(group);
    });
  }

  void _createGroup(String name, String description) {
    // Implement group creation logic here
    final newGroup = Group(name, description, []);
    setState(() {
      groups.add(newGroup);
    });

    // Close the dialog and return to the main screen
    Navigator.of(context).pop();
  }

  void _showCreateGroupDialog(BuildContext context) {
    String groupName = '';
    String groupDescription = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  groupName = value;
                },
                decoration: InputDecoration(labelText: 'Group Name'),
              ),
              TextField(
                onChanged: (value) {
                  groupDescription = value;
                },
                decoration: InputDecoration(labelText: 'Group Description'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Create'),
              onPressed: () {
                _createGroup(groupName, groupDescription);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 70, 114, 137),
        title: Text('Group Manager'),
      ),
      body: GroupListScreen(groups, _deleteGroup, dummyUsers),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 70, 114, 137),
        onPressed: () {
          _showCreateGroupDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class GroupListScreen extends StatelessWidget {
  final List<Group> groups;
  final Function(Group) onDelete;
  final List<User> dummyUsers;

  GroupListScreen(this.groups, this.onDelete, this.dummyUsers);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];

        return ListTile(
          title: Text(group.name),
          subtitle: Text(group.description),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              onDelete(group);
            },
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => GroupDetailScreen(group, dummyUsers),
              ),
            );
          },
        );
      },
    );
  }
}

class GroupDetailScreen extends StatefulWidget {
  final Group group;
  final List<User> dummyUsers;

  GroupDetailScreen(this.group, this.dummyUsers);

  @override
  _GroupDetailScreenState createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  List<User> selectedUsers = [];

  void _showUserListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Users'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                children: widget.dummyUsers.map((user) {
                  final isSelected = selectedUsers.contains(user);
                  return ListTile(
                    title: Text(user.name),
                    trailing: isSelected ? Icon(Icons.check) : null,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedUsers.remove(user);
                        } else {
                          selectedUsers.add(user);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                // Add selected users to the group
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _removeUser(User user) {
    setState(() {
      selectedUsers.remove(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 70, 114, 137),
        title: Text(widget.group.name),
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          Text(widget.group.description),
          SizedBox(height: 20,),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: const Color.fromARGB(255, 70, 114, 137),),
              onPressed: () {
                _showUserListDialog(context);
              },
              child: Text('Add Members'),
            ),
          ),
          Column(
            children: selectedUsers.map((user) {
              return ListTile(
                title: Text(user.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete,color: Colors.red,),
                  onPressed: () {
                    _removeUser(user);
                  },
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}