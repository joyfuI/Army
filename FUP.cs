namespace FUP
{
	public class CONSTANTS
	{
		public const uint REQ_FILE_SEND = 0x01;
		public const uint REP_FILE_SEND = 0x02;
		public const uint FILE_SEND_DATA = 0x03;
		public const uint FILE_SEND_RES = 0x04;

		public const byte NOT_FRAGMENTED = 0x00;
		public const byte FRAGMENTED = 0x01;

		public const byte NOT_LASTMSG = 0x00;
		public const byte LASTMSG = 0x01;

		public const byte ACCEPTED = 0x00;
		public const byte DENIED = 0x01;

		public const byte FAIL = 0x00;
		public const byte SUCCESS = 0x01;
	}

	public interface ISerializable
	{
		byte[] GetBytes();
		int GetSize();
	}

	public class Message : ISerializable
	{
		public Header Header { get; set; }
		public ISerializable Body { get; set; }

		public byte[] GetBytes()
		{
			byte[] bytes = new byte[GetSize()];

			Header.GetBytes().CopyTo(bytes, 0);
			Body.GetBytes().CopyTo(bytes, Header.GetSize());

			return bytes;
		}

		public int GetSize()
		{
			return Header.GetSize() + Body.GetSize();
		}
	}

	public class Header : ISerializable
	{
		public uint MSGID { get; set; }
		public uint MSGTYPE { get; set; }
		public uint BODYLEN { get; set; }
		public byte FRAGMENTED { get; set; }
		public byte LASTMSG { get; set; }
		public ushort SEQ { get; set; }

		public Header() { }
		public Header(byte[] bytes)
		{
			MSGID = System.BitConverter.ToUInt32(bytes, 0);
			MSGTYPE = System.BitConverter.ToUInt32(bytes, 4);
			BODYLEN = System.BitConverter.ToUInt32(bytes, 8);
			FRAGMENTED = bytes[12];
			LASTMSG = bytes[13];
			SEQ = System.BitConverter.ToUInt16(bytes, 14);
		}

		public byte[] GetBytes()
		{
			byte[] bytes = new byte[16];

			byte[] temp = System.BitConverter.GetBytes(MSGID);
			System.Array.Copy(temp, 0, bytes, 0, temp.Length);

			temp = System.BitConverter.GetBytes(MSGTYPE);
			System.Array.Copy(temp, 0, bytes, 4, temp.Length);

			temp = System.BitConverter.GetBytes(BODYLEN);
			System.Array.Copy(temp, 0, bytes, 8, temp.Length);

			bytes[12] = FRAGMENTED;
			bytes[13] = LASTMSG;

			temp = System.BitConverter.GetBytes(SEQ);
			System.Array.Copy(temp, 0, bytes, 14, temp.Length);

			return bytes;
		}

		public int GetSize()
		{
			return 16;
		}
	}

	public class BodyRequest : ISerializable
	{
		public long FILESIZE;
		public byte[] FILENAME;

		public BodyRequest() { }
		public BodyRequest(byte[] bytes)
		{
			FILESIZE = System.BitConverter.ToInt64(bytes, 0);
			FILENAME = new byte[bytes.Length - sizeof(long)];
			System.Array.Copy(bytes, sizeof(long), FILENAME, 0, FILENAME.Length);
		}

		public byte[] GetBytes()
		{
			byte[] bytes = new byte[GetSize()];
			byte[] temp = System.BitConverter.GetBytes(FILESIZE);
			System.Array.Copy(temp, 0, bytes, 0, temp.Length);
			System.Array.Copy(FILENAME, 0, bytes, temp.Length, FILENAME.Length);

			return bytes;
		}

		public int GetSize()
		{
			return sizeof(long) + FILENAME.Length;
		}
	}

	public class BodyResponse : ISerializable
	{
		public uint MSGID;
		public byte RESPONSE;
		public BodyResponse() { }
		public BodyResponse(byte[] bytes)
		{
			MSGID = System.BitConverter.ToUInt32(bytes, 0);
			RESPONSE = bytes[4];
		}

		public byte[] GetBytes()
		{
			byte[] bytes = new byte[GetSize()];
			byte[] temp = System.BitConverter.GetBytes(MSGID);
			System.Array.Copy(temp, 0, bytes, 0, temp.Length);
			bytes[temp.Length] = RESPONSE;

			return bytes;
		}

		public int GetSize()
		{
			return sizeof(uint) + sizeof(byte);
		}
	}

	public class BodyData : ISerializable
	{
		public byte[] DATA;

		public BodyData(byte[] bytes)
		{
			DATA = new byte[bytes.Length];
			bytes.CopyTo(DATA, 0);
		}

		public byte[] GetBytes()
		{
			return DATA;
		}

		public int GetSize()
		{
			return DATA.Length;
		}
	}

	public class BodyResult : ISerializable
	{
		public uint MSGID;
		public byte RESULT;

		public BodyResult() { }
		public BodyResult(byte[] bytes)
		{
			MSGID = System.BitConverter.ToUInt32(bytes, 0);
			RESULT = bytes[4];
		}

		public byte[] GetBytes()
		{
			byte[] bytes = new byte[GetSize()];
			byte[] temp = System.BitConverter.GetBytes(MSGID);
			System.Array.Copy(temp, 0, bytes, 0, temp.Length);
			bytes[temp.Length] = RESULT;

			return bytes;
		}

		public int GetSize()
		{
			return sizeof(uint) + sizeof(byte);
		}
	}

	public class MessageUtil
	{
		public static void Send(System.IO.Stream writer, Message msg)
		{
			writer.Write(msg.GetBytes(), 0, msg.GetSize());
		}

		public static Message Receive(System.IO.Stream reader)
		{
			int totalRecv = 0;
			int sizeToRead = 16;
			byte[] hBuffer = new byte[sizeToRead];

			while (sizeToRead > 0)
			{
				byte[] buffer = new byte[sizeToRead];
				int recv = reader.Read(buffer, 0, sizeToRead);
				if (recv == 0)
					return null;

				buffer.CopyTo(hBuffer, totalRecv);
				totalRecv += recv;
				sizeToRead -= recv;
			}

			Header header = new Header(hBuffer);

			totalRecv = 0;
			byte[] bBuffer = new byte[header.BODYLEN];
			sizeToRead = (int)header.BODYLEN;

			while (sizeToRead > 0)
			{
				byte[] buffer = new byte[sizeToRead];
				int recv = reader.Read(buffer, 0, sizeToRead);
				if (recv == 0)
					return null;

				buffer.CopyTo(bBuffer, totalRecv);
				totalRecv += recv;
				sizeToRead -= recv;
			}

			ISerializable body = null;
			switch (header.MSGTYPE)
			{
			case CONSTANTS.REQ_FILE_SEND:
				body = new BodyRequest(bBuffer);
				break;
			case CONSTANTS.REP_FILE_SEND:
				body = new BodyResponse(bBuffer);
				break;
			case CONSTANTS.FILE_SEND_DATA:
				body = new BodyData(bBuffer);
				break;
			case CONSTANTS.FILE_SEND_RES:
				body = new BodyResult(bBuffer);
				break;
			default:
				throw new System.Exception(System.String.Format("Unknown MSGTYPE : {0}" + header.MSGTYPE));
			}

			return new Message() { Header = header, Body = body };
		}
	}
}

namespace FUPApp
{
	class MainApp
	{
		static void Main(string[] args)
		{
			const int PORT = 8810;

			if (args.Length == 1)
			{
				uint msgId = 0;

				string dir = args[0];

				System.Net.Sockets.TcpListener server = null;
				try
				{
					System.Net.IPEndPoint localAddress = new System.Net.IPEndPoint(0, PORT);
					server = new System.Net.Sockets.TcpListener(localAddress);
					server.Start();

					System.Console.WriteLine("파일 다운로드 대기 중...");

					while (true)
					{
						System.Net.Sockets.TcpClient client = server.AcceptTcpClient();
						System.Console.WriteLine("{0} 연결", ((System.Net.IPEndPoint)client.Client.RemoteEndPoint).ToString());

						System.Net.Sockets.NetworkStream stream = client.GetStream();
						FUP.Message reqMsg = FUP.MessageUtil.Receive(stream);

						if (reqMsg.Header.MSGTYPE != FUP.CONSTANTS.REQ_FILE_SEND)
						{
							stream.Close();
							client.Close();
							continue;
						}

						FUP.BodyRequest reqBody = (FUP.BodyRequest)reqMsg.Body;

						System.Console.WriteLine("파일 전송 요청이 왔습니다. 수락하시겠습니까? (yes/no)");
						string answer = System.Console.ReadLine();

						FUP.Message rspMsg = new FUP.Message();
						rspMsg.Body = new FUP.BodyResponse() {
							MSGID = reqMsg.Header.MSGID,
							RESPONSE = FUP.CONSTANTS.ACCEPTED
						};
						rspMsg.Header = new FUP.Header() {
							MSGID = msgId++,
							MSGTYPE = FUP.CONSTANTS.REP_FILE_SEND,
							BODYLEN = (uint)rspMsg.Body.GetSize(),
							FRAGMENTED = FUP.CONSTANTS.NOT_FRAGMENTED,
							LASTMSG = FUP.CONSTANTS.LASTMSG,
							SEQ = 0
						};

						if (answer != "yes" && answer != "y")
						{
							rspMsg.Body = new FUP.BodyResponse() {
								MSGID = reqMsg.Header.MSGID,
								RESPONSE = FUP.CONSTANTS.DENIED
							};
							FUP.MessageUtil.Send(stream, rspMsg);
							stream.Close();
							client.Close();
							continue;
						}
						else
							FUP.MessageUtil.Send(stream, rspMsg);

						System.Console.WriteLine("파일 전송을 시작합니다.");

						if (System.IO.Directory.Exists(dir) == false)
							System.IO.Directory.CreateDirectory(dir);

						long fileSize = reqBody.FILESIZE;
						string fileName = System.Text.Encoding.Default.GetString(reqBody.FILENAME);
						System.IO.FileStream file = new System.IO.FileStream(dir + "\\" + fileName, System.IO.FileMode.Create);

						uint? dataMsgId = null;
						ushort prevSeq = 0;
						while ((reqMsg = FUP.MessageUtil.Receive(stream)) != null)
						{
							System.Console.Write("#");
							if (reqMsg.Header.MSGTYPE != FUP.CONSTANTS.FILE_SEND_DATA)
								break;

							if (dataMsgId == null)
								dataMsgId = reqMsg.Header.MSGID;
							else
							{
								if (dataMsgId != reqMsg.Header.MSGID)
									break;
							}

							if (prevSeq++ != reqMsg.Header.SEQ)
							{
								System.Console.WriteLine("{0}, {1}", prevSeq, reqMsg.Header.SEQ);
								break;
							}

							file.Write(reqMsg.Body.GetBytes(), 0, reqMsg.Body.GetSize());

							if (reqMsg.Header.FRAGMENTED == FUP.CONSTANTS.NOT_FRAGMENTED)
								break;
							if (reqMsg.Header.LASTMSG == FUP.CONSTANTS.LASTMSG)
								break;
						}

						long recvFileSize = file.Length;
						file.Close();

						System.Console.WriteLine();
						System.Console.WriteLine("수신 파일 크기 : {0}byte", recvFileSize);

						FUP.Message rstMsg = new FUP.Message();
						rstMsg.Body = new FUP.BodyResult() {
							MSGID = reqMsg.Header.MSGID,
							RESULT = FUP.CONSTANTS.SUCCESS
						};
						rstMsg.Header = new FUP.Header() {
							MSGID = msgId++,
							MSGTYPE = FUP.CONSTANTS.FILE_SEND_RES,
							BODYLEN = (uint)rstMsg.Body.GetSize(),
							FRAGMENTED = FUP.CONSTANTS.NOT_FRAGMENTED,
							LASTMSG = FUP.CONSTANTS.LASTMSG,
							SEQ = 0
						};

						if (fileSize == recvFileSize)
							FUP.MessageUtil.Send(stream, rstMsg);
						else
						{
							rstMsg.Body = new FUP.BodyResult() {
								MSGID = reqMsg.Header.MSGID,
								RESULT = FUP.CONSTANTS.FAIL
							};

							FUP.MessageUtil.Send(stream, rstMsg);
						}
						System.Console.WriteLine("파일 전송을 마쳤습니다.");

						stream.Close();
						client.Close();
					}
				}
				catch (System.Net.Sockets.SocketException e)
				{
					System.Console.WriteLine(e);
				}
				finally
				{
					server.Stop();
				}
			}
			else if (args.Length == 2)
			{
				const int CHUNK_SIZE = 4096;

				string serverIp = args[0];
				string filepath = args[1];

				try
				{
					System.Net.IPEndPoint clientAddress = new System.Net.IPEndPoint(0, 0);
					System.Net.IPEndPoint serverAddress = new System.Net.IPEndPoint(System.Net.IPAddress.Parse(serverIp), PORT);
					System.IO.FileInfo fileinfo = new System.IO.FileInfo(filepath);

					System.Console.WriteLine("클라이언트: {0}, 서버: {0}", clientAddress.ToString(), serverAddress.ToString());

					uint msgId = 0;

					FUP.Message reqMsg = new FUP.Message();
					reqMsg.Body = new FUP.BodyRequest() {
						FILESIZE = fileinfo.Length,
						FILENAME = System.Text.Encoding.Default.GetBytes(fileinfo.Name)
					};
					reqMsg.Header = new FUP.Header() {
						MSGID = msgId++,
						MSGTYPE = FUP.CONSTANTS.REQ_FILE_SEND,
						BODYLEN = (uint)reqMsg.Body.GetSize(),
						FRAGMENTED = FUP.CONSTANTS.NOT_FRAGMENTED,
						LASTMSG = FUP.CONSTANTS.LASTMSG,
						SEQ = 0
					};

					System.Net.Sockets.TcpClient client = new System.Net.Sockets.TcpClient(clientAddress);
					client.Connect(serverAddress);

					System.Net.Sockets.NetworkStream stream = client.GetStream();

					FUP.MessageUtil.Send(stream, reqMsg);

					FUP.Message rspMsg = FUP.MessageUtil.Receive(stream);

					if (rspMsg.Header.MSGTYPE != FUP.CONSTANTS.REP_FILE_SEND)
					{
						System.Console.WriteLine("정상적인 서버 응답이 아닙니다. {0}", rspMsg.Header.MSGTYPE);
						return;
					}

					if (((FUP.BodyResponse)rspMsg.Body).RESPONSE == FUP.CONSTANTS.DENIED)
					{
						System.Console.WriteLine("서버에서 파일 전송을 거부했습니다.");
						return;
					}

					using (System.IO.Stream fileStream = new System.IO.FileStream(filepath, System.IO.FileMode.Open))
					{
						byte[] rbytes = new byte[CHUNK_SIZE];

						long readValue = System.BitConverter.ToInt64(rbytes, 0);

						int totalRead = 0;
						ushort msgSeq = 0;
						byte fragmented = (fileStream.Length < CHUNK_SIZE) ? FUP.CONSTANTS.NOT_FRAGMENTED : FUP.CONSTANTS.FRAGMENTED;
						while (totalRead < fileStream.Length)
						{
							int read = fileStream.Read(rbytes, 0, CHUNK_SIZE);
							totalRead += read;
							FUP.Message fileMsg = new FUP.Message();

							byte[] sendBytes = new byte[read];
							System.Array.Copy(rbytes, 0, sendBytes, 0, read);

							fileMsg.Body = new FUP.BodyData(sendBytes);
							fileMsg.Header = new FUP.Header() {
								MSGID = msgId,
								MSGTYPE = FUP.CONSTANTS.FILE_SEND_DATA,
								BODYLEN = (uint)fileMsg.Body.GetSize(),
								FRAGMENTED = fragmented,
								LASTMSG = (totalRead < fileStream.Length) ? FUP.CONSTANTS.NOT_LASTMSG : FUP.CONSTANTS.LASTMSG,
								SEQ = msgSeq++
							};

							System.Console.Write("#");

							FUP.MessageUtil.Send(stream, fileMsg);
						}

						System.Console.WriteLine();
						FUP.Message rstMsg = FUP.MessageUtil.Receive(stream);
						FUP.BodyResult result = (FUP.BodyResult)rstMsg.Body;
						System.Console.WriteLine("파일 전송을 마쳤습니다.");
					}

					stream.Close();
					client.Close();
				}
				catch (System.Net.Sockets.SocketException e)
				{
					System.Console.WriteLine(e);
				}
			}
			else
			{
				System.Console.WriteLine("파일 받는 법:\t{0} \"다운로드 경로\"", System.Diagnostics.Process.GetCurrentProcess().ProcessName);
				System.Console.WriteLine("파일 보내는 법:\t{0} \"보낼 IP\" \"업로드할 파일\"", System.Diagnostics.Process.GetCurrentProcess().ProcessName);
			}
			return;
		}
	}
}