#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <unistd.h>

#define SRVPORT "5060"
#define MAXBUFLEN 4096

struct sockaddr_storage client_addr;
socklen_t client_addrlen;


uint16_t init_tid(long tm)
{
    int i, stime;
    stime = (unsigned) tm/2;
    srand(stime);

    // ports are allowed between 1024~6553
    return (rand()/(RAND_MAX+1.0)) * (65535 - 1024) + 1024;
}


void *sendtoo(char *sendstuff, int sock)
{
    int numbytes;
    if ((numbytes = sendto(sock, sendstuff, strlen(sendstuff), 0,
                           (struct sockaddr *)&client_addr, sizeof client_addr)) == -1)
    {
        perror("sendto");
    }
    printf("%d\n\n", numbytes);
}


char *recvfromm(int sock)
{
    socklen_t addr_size;
    int numbytes;
    static char buf[MAXBUFLEN] = {0};  /* fix "warning: function returns address of local variable",
                                          but not recommend. pass a external char * or return an array by malloc();
                                        */
    addr_size = sizeof client_addr;

    if ((numbytes = recvfrom(sock, buf, MAXBUFLEN-1 , 0,
                             (struct sockaddr *)&client_addr, &addr_size)) == -1) 
    {
        perror("recvfrom");
    }
    buf[numbytes] = '\0';
	//	printf("%s\n\n", buf);
    return buf;
}


void sip_100(int sock, char *fromvia, char *fromviaport, char *branch, char *callid, char *cseq, char *from, char *server1, char *server2, char *server3, char *interface, char *mytag)
{
    char sip_100[9999]; //"SIP/2.0 100 Trying\n"

    strcpy(sip_100, "SIP/2.0 100 Trying\r\nVia: SIP/2.0/UDP ");
    strcat(sip_100, fromvia);
    strcat(sip_100, ":");
    strcat(sip_100, fromviaport);
    strcat(sip_100, ";rport=");
    strcat(sip_100, fromviaport);
    strcat(sip_100, ";received=");
    strcat(sip_100, fromvia);
    strcat(sip_100, ";");
    strcat(sip_100, branch);
    strcat(sip_100, "\r\n");

    strcat(sip_100, "Content-Length: 0\r\n");

    strcat(sip_100, "Call-ID: ");
    strcat(sip_100, callid);
    strcat(sip_100, "\r\n");

    strcat(sip_100, cseq);
    strcat(sip_100, "\r\n");
            
    strcat(sip_100, "From: ");
    strcat(sip_100, from);
    strcat(sip_100, "\r\n");

    strcat(sip_100, "Server: ");
    strcat(sip_100, server1);
    strcat(sip_100, " ");
    strcat(sip_100, server2);
    strcat(sip_100, " ");
    strcat(sip_100, server3);
    strcat(sip_100, "\r\n");

    strcat(sip_100, "To: \"unknown\"<sip:");
    strcat(sip_100, interface);
    //strcat(sip_100, ">;tag=1111111111111111111\r\n\r\n");
            
    strcat(sip_100, ">;tag=1111111111111");
    strcat(sip_100, mytag);
    strcat(sip_100, "\r\n\r\n");
            
    sendtoo(sip_100, sock);
}


void sip_180(int sock, char *fromvia, char *fromviaport, char *branch, char *interface, char *port, char *callid, char *cseq, char *from, char *server1, char *server2, char *server3, char *mytag)
{
    char sip_180[9999]; //"SIP/2.0 180 Ringing\n"

    strcpy(sip_180, "SIP/2.0 180 Ringing\r\nVia: SIP/2.0/UDP ");
    strcat(sip_180, fromvia);
    strcat(sip_180, ":");
    strcat(sip_180, fromviaport);
    strcat(sip_180, ";rport=");
    strcat(sip_180, fromviaport);
    strcat(sip_180, ";received=");
    strcat(sip_180, fromvia);
    strcat(sip_180, ";");
    strcat(sip_180, branch);
    strcat(sip_180, "\r\n");

    strcat(sip_180, "Content-Length: 0\r\n");

    strcat(sip_180, "Contact: <sip:");
    strcat(sip_180, interface);
    strcat(sip_180, ":");
    strcat(sip_180, port);
    strcat(sip_180, ">\r\n");

    strcat(sip_180, "Call-ID: ");
    strcat(sip_180, callid);
    strcat(sip_180, "\r\n");

    strcat(sip_180, cseq);
    strcat(sip_180, "\r\n");
			
    strcat(sip_180, "From: ");
    strcat(sip_180, from);
    strcat(sip_180, "\r\n");

    strcat(sip_180, "Server: ");
    strcat(sip_180, server1);
    strcat(sip_180, " ");
    strcat(sip_180, server2);
    strcat(sip_180, " ");
    strcat(sip_180, server3);
    strcat(sip_180, "\r\n");

    strcat(sip_180, "To: \"unknown\"<sip:");
    strcat(sip_180, interface);
    //strcat(sip_180, ">;tag=1111111111111111111\r\n\r\n");
			
    strcat(sip_180, ">;tag=1111111111111");
    strcat(sip_180, mytag);
    strcat(sip_180, "\r\n\r\n");
			
    sendtoo(sip_180, sock);
}


void sip_200(int sock, char *fromvia, char *fromviaport, char *branch, char *interface, char *port, char *callid, char *cseq, char *from, char *server1, char *server2, char *server3, char *mytag, char *vv, char *oo, char *ss, char *cc, char *tt, char *aa, char *mm1, char *mm2, char *mm3, char *mm4, char *mm5, char *rtpmap3, char *rtpmap101, char *fmtp)
{
    char sip_200[9999]; //"SIP/2.0 200 OK\n"

    strcpy(sip_200, "SIP/2.0 200 OK\r\n");
    strcat(sip_200, "Via: SIP/2.0/UDP ");
    strcat(sip_200, fromvia);
    strcat(sip_200, ":");
    strcat(sip_200, fromviaport);
    strcat(sip_200, ";rport=");
    strcat(sip_200, fromviaport);
    strcat(sip_200, ";received=");
    strcat(sip_200, fromvia);
    strcat(sip_200, ";");
    strcat(sip_200, branch);
    strcat(sip_200, "\r\n");

    strcat(sip_200, "Content-Length: 216\r\n");

    strcat(sip_200, "Contact: <sip:");
    strcat(sip_200, interface);
    strcat(sip_200, ":");
    strcat(sip_200, port);
    strcat(sip_200, ">\r\n");

    strcat(sip_200, "Call-ID: ");
    strcat(sip_200, callid);
    strcat(sip_200, "\r\n");

    strcat(sip_200, "Content-Type: application/sdp\r\n");

    strcat(sip_200, cseq);
    strcat(sip_200, "\r\n");
			
    strcat(sip_200, "From: ");
    strcat(sip_200, from);
    strcat(sip_200, "\r\n");

    strcat(sip_200, "Server: ");
    strcat(sip_200, server1);
    strcat(sip_200, " ");
    strcat(sip_200, server2);
    strcat(sip_200, " ");
    strcat(sip_200, server3);
    strcat(sip_200, "\r\n");

    strcat(sip_200, "To: \"unknown\"<sip:");
    strcat(sip_200, interface);
    //	strcat(sip_200, ">;tag=1111111111111111111\r\n\r\n");
			
    strcat(sip_200, ">;tag=1111111111111");
    strcat(sip_200, mytag);
    strcat(sip_200, "\r\n\r\n");
			
    /* body */
    strcat(sip_200, vv);
    strcat(sip_200, "\r\n");
    strcat(sip_200, oo);
    strcat(sip_200, "\r\n");
    strcat(sip_200, ss);
    strcat(sip_200, "\r\n");
    strcat(sip_200, cc);
    strcat(sip_200, "\r\n");
    strcat(sip_200, tt);
    strcat(sip_200, "\r\n");
    strcat(sip_200, aa);
    strcat(sip_200, "\r\n");
    strcat(sip_200, mm1);
    strcat(sip_200, " ");
    strcat(sip_200, mm2);
    strcat(sip_200, " ");
    strcat(sip_200, mm3);
    strcat(sip_200, " ");
    strcat(sip_200, mm4);
    strcat(sip_200, " ");
    strcat(sip_200, mm5);
    strcat(sip_200, "\r\n");
    strcat(sip_200, rtpmap3);
    strcat(sip_200, "\r\n");
    strcat(sip_200, rtpmap101);
    strcat(sip_200, "\r\n");
    strcat(sip_200, fmtp);
    strcat(sip_200, "\r\n");
    sendtoo(sip_200, sock);
}


void bye(int sock, char *fromvia, char *fromviaport, char *interface, char *mybranch, char *callid, char *port, char *mytag, char *from, char *server1, char *server2, char *server3)
{
    char bye[9999]; //BYE sip:192.168.1.6:5060 SIP/2.0
    strcpy(bye, "BYE sip:");
    strcat(bye, fromvia);
    strcat(bye, ":");
    strcat(bye, fromviaport);
    strcat(bye, " SIP/2.0\r\n");

    strcat(bye, "Via: SIP/2.0/UDP ");
    strcat(bye, interface);
    //strcat(bye, ";rport;branch=z9hG4bKc0a80108000000814f91a6c63c4fc60000002222\r\n");
			
    strcat(bye, ";rport;branch=z9hG4bKc0a80108000000814f91a6c63c4fc60000");
    strcat(bye, mybranch);
    strcat(bye, "\r\n");
			

    strcat(bye, "Content-Length: 0\r\n");

    strcat(bye, "Call-ID: ");
    strcat(bye, callid);
    strcat(bye, "\r\n");

    strcat(bye, "CSeq: 1 BYE\r\n");

    strcat(bye, "From: \"unknown\"<sip:");
    strcat(bye, interface);
    strcat(bye, ":");
    strcat(bye, port);
    //strcat(bye, ">;tag=1111111111111111111\r\n");
		
    strcat(bye, ">;tag=1111111111111");
    strcat(bye, mytag);
    strcat(bye, "\r\n");
			

    strcat(bye, "Max-Forwards: 70\r\n");

    strcat(bye, "To: ");
    strcat(bye, from);
    strcat(bye, "\r\n");

    strcat(bye, "User-Agent: ");
    strcat(bye, server1);
    strcat(bye, " ");
    strcat(bye, server2);
    strcat(bye, " ");
    strcat(bye, server3);
    strcat(bye, "\r\n\r\n");
    sendtoo(bye, sock);
}


int main(void)
{
    int sockfd;
    struct addrinfo hints, *res, *p;
    int st, on = 1;
    /* struct sockaddr_storage client_addr; */
    /* socklen_t client_addrlen; */
    char buf[MAXBUFLEN];
    char lastbuf[MAXBUFLEN];
    int nbytes_recv, nbytes_send;
    char ipaddr[INET6_ADDRSTRLEN];

    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_DGRAM;
    hints.ai_flags = AI_PASSIVE;

    if ((st = getaddrinfo(NULL, SRVPORT, &hints, &res)) != 0) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(st));
        exit(EXIT_FAILURE);
    }

    for(p=res; p!=NULL; p=p->ai_next) {
        if ((sockfd = socket(p->ai_family, p->ai_socktype, p->ai_protocol)) == -1) {
            perror("WARNING(socket)");
            continue;
        }
        if (setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(int)) == -1) {
            perror("WARNING(setsockopt)");
            exit(EXIT_FAILURE);
        }
        if (bind(sockfd, p->ai_addr, p->ai_addrlen) == -1) {
            close(sockfd);
            perror("WARNING(bind)");
            continue;
        }
        break;
    }

    if (p == NULL) {
        fprintf(stderr, "ERROR: unable to create a socket.\n");
        exit(EXIT_FAILURE);
    }

    freeaddrinfo(res);

    printf("SIP: started at port %s...\n", SRVPORT);


    for(;;) {
        client_addrlen = sizeof client_addr;
        if ((nbytes_recv = recvfrom(sockfd, buf, sizeof buf, 0,
                                    (struct sockaddr *)&client_addr,
                                    &client_addrlen)) == -1) {
            perror("WARNING(recvfrom)");
            continue;
        }

        if(strncmp(buf, "INVITE sip:", strlen("INVITE sip:")) == 0) {
            printf("Yes! SIP\n");
            pid_t pid;
            pid = fork();
            if (pid == 0) {
                close(sockfd);
                int new_sfd;
                struct addrinfo new_hints;
                uint16_t mytid, clttid;
                char myport[6];

                memset(&new_hints, 0, sizeof new_hints);
                new_hints.ai_family = AF_UNSPEC;
                new_hints.ai_socktype = SOCK_DGRAM;
                new_hints.ai_flags = AI_PASSIVE;

                long tm = time(NULL);
                mytid = init_tid(tm - 10);      // different with child process forked
                sprintf(myport, "%u", mytid);
                printf("new child: new port %s.\n", myport);

                if ((st = getaddrinfo(NULL, myport, &new_hints, &res)) != 0) {
                    fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(st));
                    exit(EXIT_FAILURE);
                }

                for(p=res; p!=NULL; p=p->ai_next) {
                    if ((new_sfd = socket(p->ai_family, p->ai_socktype, p->ai_protocol)) == -1) {
                        perror("WARNING(socket)");
                        continue;
                    }
                    if (setsockopt(new_sfd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(int)) == -1) {
                        perror("WARNING(setsockopt)");
                        exit(EXIT_FAILURE);
                    }
                    if (bind(new_sfd, p->ai_addr, p->ai_addrlen) == -1) {
                        close(new_sfd);
                        perror("WARNING(bind)");
                        continue;
                    }
                    break;
                }

                if (p == NULL) {
                    fprintf(stderr, "ERROR: unable to create a socket.\n");
                    exit(EXIT_FAILURE);
                }
                freeaddrinfo(res);

                char *buff=NULL;
                char via[128]={0}, callid[128]={0}, cseq[128]={0}, from[128]={0}, server1[128]={0}, server2[128]={0}, server3[128]={0}, vv[128]={0}, oo[128]={0}, ss[128]={0}, cc[128]={0}, tt[128]={0}, aa[128]={0}, mm1[128]={0}, mm2[128]={0}, mm3[128]={0}, mm4[128]={0}, mm5[128]={0}, rtpmap3[128]={0}, rtpmap101[128]={0}, fmtp[128]={0};


                buff = strtok(buf, "\r\n");
                while(buff != NULL)
                {   
                    if(strncmp(buff, "Via:", 4) == 0)
                    {
                        sscanf(buff, "%*s %*s %s", via);
                    }
                    if(strncmp(buff, "Call-ID:", 8) == 0)
                    {
                        sscanf(buff, "%*s %s", callid);
                    }
                    if(strncmp(buff, "CSeq:", 5) == 0)
                    {
                        strcpy(cseq, buff);
                    }
                    if(strncmp(buff, "From:", 5) == 0)
                    {
                        sscanf(buff, "%*s %s", from);
                    }
                    if(strncmp(buff, "User-Agent:", 11) == 0)
                    {
                        sscanf(buff, "%*s %s %s %s", server1, server2, server3);
                    }
                    if(strncmp(buff, "v=", 2) == 0)
                    {
                        strcpy(vv, buff);
                    }
                    if(strncmp(buff, "o=", 2) == 0)
                    {
                        strcpy(oo, buff);
                    }
                    if(strncmp(buff, "s=", 2) == 0)
                    {
                        strcpy(ss, buff);
                    }
                    if(strncmp(buff, "c=", 2) == 0)
                    {
                        strcpy(cc, buff);
                    }
                    if(strncmp(buff, "t=", 2) == 0)
                    {
                        strcpy(tt, buff);
                    }
                    if(strncmp(buff, "a=direction", 11) == 0)
                    {
                        strcpy(aa, buff);
                    }
                    if(strncmp(buff, "m=", 2) == 0)
                    {
                        sscanf(buff, "%s %s %s %s %*s %*s %*s %*s %*s %s", mm1, mm2, mm3, mm4, mm5);
                    }
                    if(strncmp(buff, "a=rtpmap:3", 10) == 0)
                    {
                        strcpy(rtpmap3, buff);
                    }
                    if(strncmp(buff, "a=rtpmap:101", 12) == 0)
                    {
                        strcpy(rtpmap101, buff);
                    }
                    if(strncmp(buff, "a=fmtp", 6) == 0)
                    {
                        strcpy(fmtp, buff);
                    }

                    buff = strtok(NULL, "\r\n");
                }

                char viaa[4][128];
                char *fromvia, *branch, *fromviaport;
                int j=0;
                buff = strtok(via, ":");
                while(buff != NULL)
                {
                    strcpy(viaa[j], buff);
                    j++;
                    buff = strtok(NULL, ";");
                }
                fromvia = viaa[0];
                fromviaport = viaa[1];
                branch = viaa[3];

                char * interface = "192.168.1.101";
                char mytag[32];
                char mybranch[32];
                sprintf(mytag, "%d", mytid);
                sprintf(mybranch, "%d", mytid);

                sip_100(new_sfd, fromvia,   fromviaport,
                        branch,  callid,    cseq,
                        from,    server1,   server2,
                        server3, interface, mytag);

                sip_180(new_sfd, fromvia,   fromviaport,
                        branch,  interface, myport,
                        callid,  cseq,      from,
                        server1, server2,   server3,
                        mytag);

                sip_200(new_sfd, fromvia,   fromviaport,
                        branch,  interface, myport,
                        callid,  cseq,      from,
                        server1, server2,   server3,
                        mytag,
                        vv, oo, ss, cc, tt, aa,
                        mm1, mm2, mm3, mm4, mm5,
                        rtpmap3, rtpmap101, fmtp);

                if(strncmp(recvfromm(new_sfd), "ACK sip:", strlen("ACK sip:")) == 0) {
                    printf("Call established !\n\n");
                }

                printf("sleeping...\n");
                sleep(5);
                printf("sleep done.\n");

                bye(new_sfd,   fromvia,  fromviaport,
                    interface, mybranch, callid,
                    myport,    mytag,    from,
                    server1,   server2,  server3);

                if(strncmp(recvfromm(new_sfd), "SIP/2.0 200 OK", strlen("SIP/2.0 200 OK")) == 0) {
                    printf("Hangup !\n\n");
                }

                close(new_sfd);
                exit(0);
            } // end child
            else {
                ;
            }
        }
        else {
            printf("NO a SIP INVITE packet.\n");
        }

    }

    return 0;
}
