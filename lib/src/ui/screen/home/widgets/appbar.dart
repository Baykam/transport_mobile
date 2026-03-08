part of '../home.dart';

PreferredSizeWidget appBar({Function(UserRole?)? onPressed, UserRole? userRole, required BuildContext context}){
   return AppBar(
      scrolledUnderElevation: 0.1,
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            context.pushNamed(AppPath.filterLoads.name);
          },
          icon: Icon(Symbols.search, size: 18, color: Colors.white),
          label: Text(
            "Filter",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6366F1),
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
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