part of '../home.dart';

PreferredSizeWidget appBar({Function(UserRole?)? onPressed, UserRole? userRole}){
   return AppBar(
      scrolledUnderElevation: 0.1,
      /// just testing for ui generate for apps logic
      title: DropdownButton(
        value: userRole,
        items: UserRole.values.map((e) => DropdownMenuItem(
          value: e,
          child: Text(e.name),
        )).toList(),
        onChanged: onPressed,
      ),
      /// closing when finish your backend
      actions: [
        ElevatedButton(onPressed: (){}, child: Icon(Symbols.search, size: 20, color: Colors.black)),

        SizedBox(width: 10),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: SizedBox(
          height: 40,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 2,vertical: 2),
            itemCount: 20,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return IconButton(
                  onPressed: (){},
                  icon: Text(index.toString(), style: TextStyle(fontSize: 14, color: Colors.black))
              );
            },
          ),
        ),
      )
  );
}