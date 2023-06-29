using Microsoft.AspNet.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Services.Description;

namespace DemoStripe.Hubs
{
    public class ChatHub : Hub
    {
        public class GroupChat
        {
            public string Session { get; set; }
            public string UserConnectId { get; set; }
            public string AdminConnectId { get; set; }
            public string GroupName { get; set; }
            public List<Message> Messages { get; set; }
        }

        public class Message
        {
            public string msg { get; set; }
            public string from { get; set; }
            public string to { get; set; }
        }

        // tin nhắn chờ nếu k có admin online: user, message
        Dictionary<string, string> _channels = new Dictionary<string, string>();

        // list admin online: connectionId, adminName
        static Dictionary<string, string> admins = new Dictionary<string, string>();

        static List<GroupChat> groupChats = new List<GroupChat>();

        public void BroadcastMessage(string name, string message)
        {
            // Gửi tin nhắn đến tất cả các client đang kết nối với hub
            // call writeMessage()
            Clients.All.writeMessage(name, message);
            //Clients.writeMessage(message);
        }

        public void BroadcastMessage(string name, string message, string toUser)
        {
            // Gửi tin nhắn đến tất cả các client đang kết nối với hub
            // call writeMessage()
            Clients.All.writeMessage(name, message, toUser);
            //Clients.writeMessage(message);
        }

        // lấy id của admin login
        public void AdminOnline(string adminName)
        {
            // trong thực tế sử dụng id nên k cần clear (test k có login)
            admins.Clear();
            admins.Add(adminName, Context.ConnectionId);
        }

        public async Task<bool> JoinGroup(string session, string message)
        {
            GroupChat groupChat = groupChats.Find(g => g.Session == session);
            if (groupChat == null)
            {
                groupChat = new GroupChat();
                groupChat.UserConnectId = Context.ConnectionId;
                groupChat.Session = session;
                groupChat.AdminConnectId = getRandomAdminConnectionId();
                groupChat.GroupName = getRandomName();
                groupChat.Messages = new List<Message>();
                groupChats.Add(groupChat);

                await Groups.Add(admins["ADMIN_CSKH"], groupChat.GroupName);
            }
            await Groups.Add(Context.ConnectionId, groupChat.GroupName);
            SendMessageFromUser(session, message);
            return true;
        }

        public List<Message> GetOldMessage(string session)
        {
            GroupChat groupChat = groupChats.Find(g => g.Session == session);
            if (groupChat == null) return null;
            return groupChat.Messages;
        }

        // Gửi tin nhắn đến các user trong Group
        public void SendMessageFromUser(string session, string message)
        {
            GroupChat groupChat = groupChats.Find(g => g.Session == session);
            groupChat.Messages.Add(new Message() { from = session, msg = message, to = "ADMIN" });
            if (groupChat != null) Clients.Group(groupChat.GroupName).writeMessage(groupChat.Session, message, "admin");

        }

        public void SendMessageToGroup(string session, string message)
        {
            List<GroupChat> groupChatsOfConnectId = groupChats.FindAll(g => g.AdminConnectId == Context.ConnectionId);
            GroupChat groupChat = groupChatsOfConnectId.Find(g => g.Session == session);
            groupChat.Messages.Add(new Message() { to = session, msg = message, from = "Admin" });
            if (groupChat != null)
            {
                //if (groupChat.UserConnectId != null && groupChat.AdminConnectId != null)
                //Clients.Group(groupChat.GroupName).writeMessage(Context.User.Identity.Name, message);
                Clients.Group(groupChat.GroupName).writeMessage("ADMIN", message, groupChat.Session);

            }
        }


        private string getRandomName()
        {
            Random random = new Random();
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            StringBuilder sb = new StringBuilder(8);

            for (int i = 0; i < 8; i++)
            {
                sb.Append(chars[random.Next(chars.Length)]);
            }

            string randomString = sb.ToString();
            // check randomString đã tồn tại

            return randomString;
        }

        private string getRandomAdminConnectionId()
        {
            if (admins.Count == 0)
            {
                Console.WriteLine("Không có admin nào đang online!");
                return null;
            }
            return admins["ADMIN_CSKH"];
        }

        public override Task OnDisconnected(bool stopCalled)
        {
            // remove user, admin ra khỏi group bằng connectionId sau 1 khoảng tgian k sử dụng
            return base.OnDisconnected(stopCalled);

        }
    }
}