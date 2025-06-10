import { UserInfoKey} from '../../commons/utils/Auth'
import { QuestionDetail, User } from '../../models'
import { componentSnapshot, NodeRenderType, promptAction } from '@kit.ArkUI'
import { image } from '@kit.ImageKit'
import { fileIo, fileUri } from '@kit.CoreFileKit'
import { photoAccessHelper } from '@kit.MediaLibraryKit'

@CustomDialog
export struct QuestionShareDialog {
  @Prop item: QuestionDetail
  @StorageProp(UserInfoKey) user: User = {} as User

  controller: CustomDialogController
  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Column({ space: 20 }) {
        Image($r('app.media.ic_interview_logo'))
          .width(40)
          .height(40)
        Text('面试通，搞定企业面试题')
        Divider()
          .strokeWidth(0.5)
          .color($r('app.color.common_gray_border'))
        Text('大厂面试题：' + this.item.stem)
          .fontSize(12)
          .maxLines(2)
          .fontWeight(600)
          .width('100%')
          .lineHeight(24)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        QRCode(this.item.id)
          .width(160)
          .height(160)
          .alignSelf(ItemAlign.Center)
        Text('扫码查看答案')
          .fontSize(12)
          .alignSelf(ItemAlign.Center)
        Blank()
        Text('分享来自：' + this.user.nickName || this.user.username)
          .fontSize(12)
      }
      .id('share')//设置组件id
      .padding(20)
      .alignItems(HorizontalAlign.Start)
      .width(300)
      .height(500)
      .backgroundColor($r('app.color.white'))


      Row() {
        SaveButton({//使用该组件临时获取权限,不支持自定义样式内容,只能使用其提供的枚举
          text:SaveDescription.SAVE_IMAGE,
          buttonType:ButtonType.Normal,
          icon:SaveIconStyle.FULL_FILLED
        })
          .onClick(async (event,result)=>{//该组件仅支持点击事件,并需要传递两个参数,1.event事件,2.result执行结果
            if (result==SaveButtonOnClickResult.SUCCESS) {//结果为成功时执行逻辑, SaveButtonOnClickResult,success=1,failed = 0
              const res = await componentSnapshot.get('share')//根据组件id获取组件截图的数据流
              const packer = image.createImagePacker()//创建图片打包工具
              const arrayBuffer = await packer.packing(res, { format: 'image/jpeg', quality: 70 })//根据数据流打包图片为arrayBuffer流
              const ctx = getContext()//获取当前路径
              const imagePath = ctx.cacheDir+'/'+Date.now()+'.jpeg'//获取到cache中的图片路径,此时并未创建图片
              const imgFile = fileIo.openSync(imagePath,fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE)//创建图片路径,并给予读写权限
              fileIo.writeSync(imgFile.fd,arrayBuffer)//将arrayBuffer流写入图片,至此图片生成完成
              fileIo.closeSync(imgFile.fd)
              //转存到相册
              const imgUri = fileUri.getUriFromPath(imagePath)//获取图片在手机中的完整存储路径
              const request = photoAccessHelper.MediaAssetChangeRequest.createImageAssetRequest(ctx,imgUri)//创建变更请求
              const helper = photoAccessHelper.getPhotoAccessHelper(ctx)
              await helper.applyChanges(request)//执行请求,需要配置权限
              this.controller.close()
              promptAction.showToast({message:'已保存到本地相册'})
            }
          })
      }
      .borderRadius({ topLeft: 8 })
      .clip(true)
    }
    .borderRadius(8)
    .clip(true)
  }
}